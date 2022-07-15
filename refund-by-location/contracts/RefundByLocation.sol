pragma solidity ^0.8.0;

contract RefundByLocation {
    enum StateType { Created, Completed, OutOfCompliance }

    struct Coordinate {
        uint256 lat;
        uint256 long;
    }

    StateType public State;
    address public Owner;
    Coordinate public OfficeLocation;
    address public Employee;
    int public LastLocationUpdateTimestamp;

    mapping (address => Coordinate) public EmployeeInfo;

    function() public payable {}

    constructor(address owner, Coordinate officeLocation) public {
        Owner = owner;
        OfficeLocation = officeLocation;
    }

    // check if the location of the employee is in range
    function isUserLocationInRange(Coordinate employeeLocation) private {}

    // report the location of the employee
    function reportLocation(Coordinate employeeLocation) public payable {}

    // kill contract
    function kill() public {
        if(msg.sender == owner) selfdestruct(owner);
    }

}
