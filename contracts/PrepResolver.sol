// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { SchemaResolver } from "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";
import { IEAS, Attestation } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

// Uncomment this line to use console.log
import "hardhat/console.sol";


struct ActaEscrutinio {
    uint16 pan;
    uint16 pri;
    uint16 prd;
    uint16 verde;
    uint16 pt;
    uint16 movciu;
    uint16 morena;
    uint16 ci;
    uint16 panpriprd;
    uint16 panpri;
    uint16 panprd;
    uint16 priprd;
    uint16 verdeptmorena;
    uint16 verdept;
    uint16 verdemorena;
    uint16 ptmorena;
    // uint16 noregistrado;
    // uint16 nulos;
}

contract PrepResolver is Ownable, SchemaResolver {
    using EnumerableSet for EnumerableSet.AddressSet;

    // capacitador asistente electoral
    EnumerableSet.AddressSet private caes;

    uint32 public totalPan;
    uint32 public totalPri;
    uint32 public totalPrd;
    uint32 public totalVerde;
    uint32 public totalPt;
    uint32 public totalMovciu;
    uint32 public totalMorena;
    uint32 public totalCi;
    uint32 public totalPanpriprd;
    uint32 public totalPanpri;
    uint32 public totalPanprd;
    uint32 public totalPriprd;
    uint32 public totalVerdeptmorena;
    uint32 public totalVerdept;
    uint32 public totalVerdemorena;
    uint32 public totalPtmorena;

    // enum TipoDeCasilla {
    //     BASICA,
    //     CONTIGUA,
    //     EXTRAORDINARIA,
    //     ESPECIAL
    // }

    // struct Funcionarios {
    //     address cae;
    //     address presidente;
    //     address primerSecretario;
    //     address segundoSecretario;
    //     address primerEscrutador;
    //     address segundoEscrutador;
    //     address tercerEscrutador;
    //     address primerSuplente;
    //     address segundoSuplente;
    //     address tercerSuplente;
    // }

    /// revisar si una address es parte de los funcionarios de una casilla.
    mapping(address => mapping(address => bool)) isFuncionario;

    struct Casilla {
        /// ENTIDAD: Jalisco
        string entidad;
        /// DISTRITO: 04
        string distrito;
        /// MUNICIPIO O ALCALDIA: Zapopan
        string municipioAlcaldia;
        /// SECCION: 7969
        string seccion;
        /// CASILLA: BASICA
        // TipoDeCasilla tipo;

        address cae;
    }

    /// one CAE for each casilla
    mapping (address => Casilla) public casillas;
    // mapping (address => Funcionarios) public funcionariosCasilla;

    /// ACTA DE escrutinio y acta de incidentes.
    mapping (address => bool) public attestationActaEscrutinio;
    mapping (address => bool) public attestationActaIncidentes;

    error DuplicatedCaeForCasilla(address _cae);

    modifier onlyCaeOwner(address _cae) {
        require(msg.sender == owner() || (msg.sender == _cae && caes.contains(_cae)));
        _;
    }

    constructor(address _adminINE, IEAS _eas) Ownable(_adminINE) SchemaResolver(_eas) {}

    function getAdminINE() public view returns (address) {
        return owner();
    }

    function cargarNuevaCasillas(Casilla[] memory _casillas) public onlyOwner returns (bool) {
        uint len = _casillas.length;

        for (uint i = 0; i < len; i++) {
            Casilla memory _casilla = _casillas[i];
            if (caes.contains(_casilla.cae)) revert DuplicatedCaeForCasilla(_casilla.cae);
            casillas[_casilla.cae] = _casilla;
            caes.add(_casilla.cae);
        }

        return true;
    }

    function cargarFuncionariosCasilla(
        address[] memory _funcionarios,
        address _cae
    ) public onlyCaeOwner(_cae) returns (bool) {
        uint len = _funcionarios.length;

        for (uint i = 0; i < len; i++) {
            address _funcionario = _funcionarios[i];
            isFuncionario[_cae][_funcionario] = true;
        }

        return true;
    }

    // function decodeBytes32(bytes32[2] memory data) public pure returns (ActaEscrutinio memory) {
    function decodeBytes32(bytes32 data) public pure returns (ActaEscrutinio memory) {
        uint256 encoded0 = uint256(data);
        // uint256 encoded0 = uint256(data[0]);
        // uint256 encoded1 = uint256(data[1]);

        ActaEscrutinio memory myStruct = ActaEscrutinio({
            pan: uint16(encoded0 >> 240),
            pri: uint16(encoded0 >> 224),
            prd: uint16(encoded0 >> 208),
            verde: uint16(encoded0 >> 192),
            pt: uint16(encoded0 >> 176),
            movciu: uint16(encoded0 >> 160),
            morena: uint16(encoded0 >> 144),
            ci: uint16(encoded0 >> 128),
            panpriprd: uint16(encoded0 >> 112),
            panpri: uint16(encoded0 >> 96),
            panprd: uint16(encoded0 >> 80),
            priprd: uint16(encoded0 >> 64),
            verdeptmorena: uint16(encoded0 >> 48),
            verdept: uint16(encoded0 >> 32),
            verdemorena: uint16(encoded0 >> 16),
            ptmorena: uint16(encoded0)//,
            // noregistrado: uint16(encoded1 >> 16),
            // nulos: uint16(encoded1)
        });

        return myStruct;
    }

    // function cargarFuncionariosCasillas(Funcionario[] memory _funcionarios) public onlyOwner returns (bool) {
    //     uint len = _funcionarios.length;

    //     for (uint i = 0; i < len; i++) {
    //         Casilla memory _funcionarios = _funcionarios[i];
    //         if (caes.contains(_funcionarios.cae)) revert DuplicatedCaeForCasilla(_casilla.cae);
    //         casillas[_casilla.cae] = _casilla;
    //     }

    //     return true;
    // }

    // function getFuncionariosCasilla(address _cae) external view returns (Funcionarios memory) {
    //     Casilla memory _casilla = casillas[_cae];
    //     return Funcionarios (
    //         _casilla.presidente,
    //         _casilla.primerSecretario,
    //         _casilla.segundoSecretario,
    //         _casilla.primerEscrutador,
    //         _casilla.segundoEscrutador,
    //         _casilla.tercerEscrutador,
    //         _casilla.primerSuplente,
    //         _casilla.segundoSuplente,
    //         _casilla.tercerSuplente
    //     );
    // }

    // function updateFuncionariosCasilla(
    //     address _cae,
    //     Funcionarios memory _funcionarios
    // ) external onlyCaeOwner(_cae) returns (bool) {
    //     Casilla memory _casilla = casillas[_cae];

    //     _casilla.presidente = _funcionarios.presidente;
    //     _casilla.primerSecretario = _funcionarios.primerSecretario;
    //     _casilla.segundoSecretario = _funcionarios.segundoSecretario;
    //     _casilla.primerEscrutador = _funcionarios.primerEscrutador;
    //     _casilla.segundoEscrutador = _funcionarios.segundoEscrutador;
    //     _casilla.tercerEscrutador = _funcionarios.tercerEscrutador;
    //     _casilla.primerSuplente = _funcionarios.primerSuplente;
    //     _casilla.segundoSuplente = _funcionarios.segundoSuplente;
    //     _casilla.tercerSuplente = _funcionarios.tercerSuplente;

    //     casillas[_cae] = _casilla;

    //     return true;
    // }

    function onAttest(Attestation calldata attestation, uint256 /*value*/) internal override returns (bool) {
        address cae = attestation.attester;
        if (caes.contains(cae)) {
            // Casilla memory _casilla = casillas[cae];

            require(attestationActaEscrutinio[cae] == false);

            // bytes32 schema = attestation.schema;
            ActaEscrutinio memory acta = decodeBytes32(attestation.schema);

            totalPan += acta.pan;
            totalPri += acta.pri;
            totalPrd += acta.prd;
            totalVerde += acta.verde;
            totalPt += acta.pt;
            totalMovciu += acta.movciu;
            totalMorena += acta.morena;
            totalCi += acta.ci;
            totalPanpriprd += acta.panpriprd;
            totalPanpri += acta.panpri;
            totalPanprd += acta.panprd;
            totalPriprd += acta.priprd;
            totalVerdeptmorena += acta.verdeptmorena;
            totalVerdept += acta.verdept;
            totalVerdemorena += acta.verdemorena;
            totalPtmorena += acta.ptmorena;

            attestationActaEscrutinio[cae] = true;
            // casillas[cae] = _casilla;

            return true;

        }
        return false;
    }

    function onRevoke(Attestation calldata /*attestation*/, uint256 /*value*/) internal pure override returns (bool) {
        return true;
    }

    // function withdraw() public {
    //     // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
    //     // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

    //     require(block.timestamp >= unlockTime, "You can't withdraw yet");
    //     require(msg.sender == owner, "You aren't the owner");

    //     emit Withdrawal(address(this).balance, block.timestamp);

    //     owner.transfer(address(this).balance);
    // }
}
