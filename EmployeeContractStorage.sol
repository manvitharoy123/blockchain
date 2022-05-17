pragma solidity ^0.4.24;


contract EmployeeContractStorage {
    struct EmployeeContract {
        bool exists;
        uint salaryPerSecond;
        uint maximumSecondsPerSession;
    }

    // Employee Contract Id Counter
    uint employeeCounter;

    // Employee Contracts Storage

    mapping (address => EmployeeContract) employeeContractsMap;
    address[] keys;

    modifier employeeContractExists(address _address) {
        require(employeeContractsMap[_address].exists == true, "Employee does not exist");
        _;
    }

    modifier employeeContractDoesntExist(address _address) {
        require(employeeContractsMap[_address].exists == false, "Employee already exists");
        _;
    }

    /* Events */

    event EmployeeContractCreation (
        address indexed _from,
        address incomeAccount,
        uint salaryPerSecond,
        uint maximumSecondsPerSession
    );

    /* Constructor */ 
    
    constructor() public {
        employeeCounter = 0; 
    }

    /* Functions */

    function createEmployeeContract(address _incomeAccount, uint _salaryPerSecond, uint _maximumSecondsPerSession) 
    public  employeeContractDoesntExist(_incomeAccount)
    returns (uint) {
        // Populate Employee Contract structure in map
        employeeContractsMap[_incomeAccount].exists = true;
        employeeContractsMap[_incomeAccount].salaryPerSecond = _salaryPerSecond;
        employeeContractsMap[_incomeAccount].maximumSecondsPerSession = _maximumSecondsPerSession;

        // Add to key
        keys.push(_incomeAccount);

        // Fire event
        emit EmployeeContractCreation(msg.sender, _incomeAccount, employeeContractsMap[_incomeAccount].salaryPerSecond, employeeContractsMap[_incomeAccount].maximumSecondsPerSession);

        // Increment employee counter
        employeeCounter++;

        return employeeCounter - 1;
    }

    // Setter for Salary Per Second
    function updateSalaryPerSecond(address _employeeAddress, uint _salaryPerSecond)
    public  employeeContractExists(_employeeAddress) {
        employeeContractsMap[_employeeAddress].salaryPerSecond = _salaryPerSecond;
    }

    // Setter for Max Second Per Session
    function updateMaximumSecondsPerSession(address _employeeAddress, uint _maximumSecondsPerSession)
    public  employeeContractExists(_employeeAddress) {
        employeeContractsMap[_employeeAddress].maximumSecondsPerSession = _maximumSecondsPerSession;       
    }

    // Getter for Salary Per Second
    function readSalaryPerSecond(address _employeeAddress) 
    public employeeContractExists(_employeeAddress)
    view
    returns (uint) {
        return employeeContractsMap[_employeeAddress].salaryPerSecond;
    }

    // Getter for Max Seconds Per Session
    function readMaximumSecondsPerSession(address _employeeAddress) 
    public employeeContractExists(_employeeAddress)
    view
    returns (uint) {
        return employeeContractsMap[_employeeAddress].maximumSecondsPerSession;
    }

    function getAddressByIndex(uint _index) 
    public view
    returns (address) {
        return keys[_index];
    }

    function getNumberOfEmployees() 
    public view 
    returns (uint) {
        return employeeCounter;
    }

    function employeeExists(address _employeeAddress) 
    public view 
    returns (bool) {
        return employeeContractsMap[_employeeAddress].exists == true; // Added 2nd check for redundancy
    }

}