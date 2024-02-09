// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

contract School {

    struct Student {
        string name;
        uint score;
        uint age;
        string favColour;
        address studentAddy;
    }

    mapping(uint => Student) public students;
    mapping(address => bool) public teachers;
    address public principal;
    uint public nextId = 1;

    string public schoolName;

    event PrincipalChange(address principal, address newPrincipal);
    event RecordModification(address changer, address recordOwneer);

    event AddTeacher(address principal, address teacher);

    constructor(address principalAddy, string  memory name) {
        principal = principalAddy;
        schoolName = name;
    }

    function createStudent(address studentAddy, string memory name, uint age, string memory favColour) external onlyAuthorized {
        require(age > 0, "Age must be greater than 0");
        require(msg.sender == principal, "Only principal can create students");
        students[nextId] = Student(name, 0, age, favColour, studentAddy);
        nextId++;
    }

    function updateStudent(uint id, uint newScore, uint newAge) external onlyAuthorized {
        require(newAge > 0, "Age must be greater than 0");
        Student storage student = students[id];
        student.score = newScore;
        student.age = newAge;
        emit RecordModification(msg.sender, student.studentAddy);
    }

    function updateColor(uint id, string memory newColor) public {
        require(msg.sender == students[id].studentAddy, "Only owner of records can modiy the record");
        students[id].favColour = newColor;
        emit RecordModification(msg.sender, students[id].studentAddy);
    }

    function getStudent(uint id) public view returns (Student memory) {
        require(students[id].age != 0, "Student does not exist");
        return students[id];
    }

    function addTeacher(address teacherAddress) public {
        require(msg.sender == principal, "Only principal can add teachers");
        teachers[teacherAddress] = true;
        emit AddTeacher(msg.sender, teacherAddress);
    }

    function setPrincipal(address newPrincipal) public {
        require(msg.sender == principal, "Only principal can change principal");
        principal = newPrincipal;
        emit PrincipalChange(msg.sender, newPrincipal);
    }

    modifier onlyAuthorized() {
        require((msg.sender == principal) || (teachers[msg.sender] == true), 'only the principal or authorized teacher');
        _;
    }

    modifier onlyPrincipal() {
        require(msg.sender == principal, 'only principal can perform the action');
        _;
    }
}
