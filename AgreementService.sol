// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract AgreementService {
    address public parteUno;
    address public parteDos;
    string public descripcion;
    uint public duracionEnDias;
    uint public valorEnWei;
    uint public multaEnWei;
    bool public parteUnoEntrego;
    bool public parteDosAprobo;
    bool public terminado;

    event AcuerdoCreado(address indexed _parteUno, address indexed _parteDos, uint _valorEnEther);
    event PagoRealizado();
    event ServicioEntregado();
    event ServicioAprobado();
    
    constructor(
        address _parteUno,
        address _parteDos,
        string memory _descripcion,
        uint _duracionEnDias,
        uint _valorEnEther
    ) {
        parteUno = _parteUno;
        parteDos = _parteDos;
        descripcion = _descripcion;
        duracionEnDias = _duracionEnDias;
        valorEnWei = _valorEnEther * 1 ether;
        multaEnWei = valorEnWei / 10;
        emit AcuerdoCreado(parteUno, parteDos, _valorEnEther);
    }

}