// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SistemaDeVotacion {
    address public administrador;
    bool public votacionAbierta;
    uint256 public totalVotos;

    struct Candidato {
        string nombre;
        uint256 votos;
    }

    Candidato[] public candidatos;

    mapping(address => bool) public haVotado;

    event VotoRegistrado(address votante, uint256 indiceCandidato);

    modifier soloAdministrador() {
        require(msg.sender == administrador, "Solo el administrador puede realizar esta operacion");
        _;
    }

    modifier votacionAbiertaModificador() {
        require(votacionAbierta, "La votacion esta cerrada");
        _;
    }

    constructor(string[] memory nombresCandidatos) {
        administrador = msg.sender;
        votacionAbierta = true;

        for (uint256 i = 0; i < nombresCandidatos.length; i++) {
            candidatos.push(Candidato({
                nombre: nombresCandidatos[i],
                votos: 0
            }));
        }
    }

    function iniciarVotacion() external soloAdministrador {
        require(!votacionAbierta, "La votacion ya esta en curso");
        votacionAbierta = true;
    }

    function cerrarVotacion() external soloAdministrador {
        require(votacionAbierta, "La votacion ya esta cerrada");
        votacionAbierta = false;
    }

    function emitirVoto(uint256 indiceCandidato) external votacionAbiertaModificador {
        require(!haVotado[msg.sender], "Ya has emitido tu voto");
        require(indiceCandidato < candidatos.length, "Indice de candidato invalido");

        haVotado[msg.sender] = true;
        candidatos[indiceCandidato].votos++;
        totalVotos++;

        emit VotoRegistrado(msg.sender, indiceCandidato);
    }

    function obtenerCandidatos() external view returns (string[] memory nombres) {
        nombres = new string[](candidatos.length);
        for (uint256 i = 0; i < candidatos.length; i++) {
            nombres[i] = candidatos[i].nombre;
        }
    }

    function obtenerVoto(address votante) external view returns (uint256 indiceCandidato) {
        require(haVotado[votante], "El votante no ha votado");
        for (uint256 i = 0; i < candidatos.length; i++) {
            if (haVotado[votante]) {
                return i;
            }
        }
    }
}