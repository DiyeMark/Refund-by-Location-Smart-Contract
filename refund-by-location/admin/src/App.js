import './App.css';
import { ethers } from "ethers";
import {useEffect, useState} from "react";
import RefundByLocation from "./artifacts/contracts/RefundByLocation.sol/RefundByLocation.json";
import "antd/dist/antd.css";
import {
    Table,
    Button,
    Input,
} from 'antd';


function App() {
    const [employeeAddress, setEmployeeAddress] = useState("");
    const [newRadius, setNewRadius] = useState("");
    const [employees, setEmployees] = useState([]);
    const [radius, setRadius] = useState("");
    const [location, setLocation] = useState({
        "lat": "",
        "long": ""
    });
    const contractAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3";

    const columns = [
        {
            title: 'Employee Public Address',
            dataIndex: '',
            key: '',
            render: (text) => <a>{text}</a>,
        },
    ]


    const connectWallet = async () => {
        try {
            const { ethereum } = window;

            if (!ethereum) {
                alert("Please install MetaMask!");
                return;
            }

            const accounts = await ethereum.request({
                method: "eth_requestAccounts",
            });

            console.log("Connected", accounts[0]);
        } catch (error) {
            console.log(error);
        }
    };

    const fetchEmployees = async () => {
        const { ethereum } = window;

        if (!ethereum) {
            alert("Please install MetaMask!");
            return;
        }

        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
            contractAddress,
            RefundByLocation.abi,
            provider
        );

        const employees = await contract.getEmployee();
        setEmployees(employees);
        console.log(employees);
    };

    const addEmployee = async () => {
        const { ethereum } = window;

        if (!ethereum) {
            alert("Please install MetaMask!");
            return;
        }

        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
            contractAddress,
            RefundByLocation.abi,
            signer
        );

        const employee = await contract.addEmployee(employeeAddress);
        await employee.wait();
    };

    const getRadius = async () => {
        const { ethereum } = window;

        if (!ethereum) {
            alert("Please install MetaMask!");
            return;
        }

        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
            contractAddress,
            RefundByLocation.abi,
            provider
        );

        const rad = await contract.Radius();
        setRadius(rad.toString());
    };

    const getLocation = async () => {
        const { ethereum } = window;

        if (!ethereum) {
            alert("Please install MetaMask!");
            return;
        }

        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(
            contractAddress,
            RefundByLocation.abi,
            provider
        );

        const loc = await contract.OfficeLocation();
        setLocation({lat: loc.toString().split(',')[0], long: loc.toString().split(',')[1]});
    };

    const setContractRadius = async () => {};

    const setContractLocation = async () => {};

    useEffect(() => {
        connectWallet();
        fetchEmployees();
        getRadius();
        getLocation();
    }, []);

  return (
      <div className="App h-screen space-y-4">
          <Table columns={columns} dataSource={employees} />
          <Input.Group compact>
              <Input
                  style={{
                      width: 'calc(100% - 200px)',
                  }}
                  onChange={(e) => setEmployeeAddress(e.target.value)}
                  placeholder="employye public address"
                  defaultValue=""
              />
              <Button type="primary" onClick={addEmployee}>Add Employee</Button>
          </Input.Group>
          <Input.Group compact>
              <Input
                  style={{
                      width: 'calc(100% - 200px)',
                  }}
                  onChange={(e) => setNewRadius(e.target.value)}
                  placeholder= {radius}
              />
              <Button type="primary" onClick={setContractRadius}>Change Radius</Button>
          </Input.Group>
          <Input.Group compact>
              <Input
                  style={{
                      width: '20%',
                  }}
                  placeholder={location.lat}
              />
              <Input
                  style={{
                      width: '30%',
                  }}
                  placeholder={location.long}
              />
              <Button type="primary" onClick={setContractLocation}>Change Location</Button>
          </Input.Group>
       </div>
  );
}

export default App;
