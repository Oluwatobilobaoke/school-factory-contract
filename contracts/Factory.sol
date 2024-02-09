// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "./School.sol";

contract SchoolFactory {
    address public owner; // Contract owner
    mapping(address => School) public deployedSchools; // Deployed schools mapping

    event SchoolCreated(address schoolAddress, address creator);

    constructor() {
        owner = msg.sender;
    }

    /// @dev Deploys a new School contract instance
    function createSchool(
        string memory name,
        address principalAddress
    ) public payable {

        School school = new School(principalAddress, name);
        deployedSchools[school.principal()] = school; // Map school to principal
        emit SchoolCreated(address(school), msg.sender);

        // Transfer deployment fee to owner
        payable(owner).transfer(msg.value);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
}
