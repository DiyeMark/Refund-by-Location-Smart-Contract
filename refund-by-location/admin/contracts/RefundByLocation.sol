pragma solidity ^0.8.9;

contract RefundByLocation {

    struct Coordinate {
        uint256 lat;
        uint256 long;
    }

    address public Owner;
    uint256 public Radius;
    Coordinate public OfficeLocation;
    address[] public Employees;
    int public LastLocationUpdateTimestamp;
    uint public PayPerHour;

    struct EmployeeLocationInfo {
        mapping (uint256 => Coordinate) LocationAtTimeStamp;
    }

    mapping (address => EmployeeLocationInfo) EmployeeLocationInfos;


    constructor(address owner,uint256 officeLocationLat, uint256 officeLocationLong ,uint256 radius, uint payPerHour) public payable {
        Owner = owner;
        OfficeLocation = Coordinate({lat: officeLocationLat, long: officeLocationLong });
        Radius = radius;
        PayPerHour = payPerHour;
    }

    function getEmployee() view public returns (address[] memory) {
        return Employees;
    }

    function addEmployee(address employeeAddress) public {
        require(msg.sender == Owner, "Must be owner");
        Employees.push(employeeAddress);
    }

    function isEmployee(address userAddress) view public returns(bool) {
        for (uint i = 0; i < Employees.length; i++) {
            if (Employees[i] == userAddress) return true;
        }
        return false;
    }

    function getEmployeeLocationInfo(address employeeAdd, uint256 timeStamp) public view {

        EmployeeLocationInfo storage employeeLocation = EmployeeLocationInfos[employeeAdd];

        //        console.log("over here lat", employeeLocation.LocationAtTimeStamp[timeStamp].lat);

        //        console.log("over here long", employeeLocation.LocationAtTimeStamp[timeStamp].long);

        // return employeeLocation[timeStamp];
    }

    function sqrt(uint x) pure public returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    // check if the location of the employee is in range
    function isUserLocationInRange(Coordinate memory employeeLocation) view private returns(bool) {
        uint lat = employeeLocation.lat - OfficeLocation.lat;
        uint long = employeeLocation.long - OfficeLocation.long;

        uint disLat = (lat * 3141592653589793238 * 6371) / 180;
        uint disLong = (long * 3141592653589793238 * 6371) / 180;

        uint distance = sqrt((disLat)**2 + (disLong)**2);
        if (distance <= (Radius * 1000000000000000000)) {
            return true;
        }
        return false;
    }

    // report the location of the employee
    function reportLocation(uint256 employeeLocationCoordinateLat, uint256 employeeLocationCoordinateLong , uint256 timeStamp) payable public {
        require(isEmployee(msg.sender), "Unknown employee");
        EmployeeLocationInfo storage employeeLocationInfo = EmployeeLocationInfos[msg.sender];
        employeeLocationInfo.LocationAtTimeStamp[timeStamp] = Coordinate({lat: employeeLocationCoordinateLat, long: employeeLocationCoordinateLong });

        if (isUserLocationInRange(Coordinate({lat: employeeLocationCoordinateLat, long: employeeLocationCoordinateLong }))) {
            payable(msg.sender).transfer(PayPerHour);
        }
    }
}
