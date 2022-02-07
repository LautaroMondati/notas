// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <= 0.8.7;
pragma experimental ABIEncoderV2;

contract notas {
    struct calificacion{
        string asignatura;
        uint nota;
    }
    struct solicitud{
        string asignatura;
        string _idAlumno;
    }
    address public profesor;
    mapping (bytes32 => calificacion []) Notas;
    solicitud [] revisiones;
    event alumno_evaluado(string, uint);
    event solicitar_revision(string);
    
    constructor () {
        profesor = msg.sender;
    }

    function Evaluar(string memory _idAlumno, uint _nota, string memory _asignatura) public UnicamenteProfesor(msg.sender) {
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        Notas[hash_idAlumno].push(calificacion(_asignatura, _nota));
        emit alumno_evaluado(_idAlumno, _nota);
    }

    modifier UnicamenteProfesor(address _direccion){
        require(_direccion == profesor, "No tienes permisos para ejecutar esta funcion.");
        _;
    }

    function VerNotas(string memory _idAlumno) public view returns(calificacion [] memory){
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        return Notas[hash_idAlumno];
    }

    function Revision(string memory _idAlumno, string memory _asignatura) public {
        revisiones.push(solicitud(_asignatura, _idAlumno));
        emit solicitar_revision(_idAlumno);
    }

    function VerSolicitudesDeRevision() public view UnicamenteProfesor(msg.sender) returns (solicitud [] memory){
        return revisiones;
    }
}