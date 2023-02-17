// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract AgreementService {
    address public parteUno;
    address public parteDos;
    string public descripcion;
    uint256 public duracionEnDias;
    uint256 public valorEnWei;
    uint256 public multaEnWei;
    bool public parteUnoEntrego;
    bool public parteDosAprobo;
    bool public terminado;

    event AcuerdoCreado(
        address indexed _parteUno,
        address indexed _parteDos,
        uint256 _valorEnEther
    );
    event PagoRealizado();
    event ServicioEntregado();
    event ServicioAprobado();

    constructor(
        address _parteUno,
        address _parteDos,
        string memory _descripcion,
        uint256 _duracionEnDias,
        uint256 _valorEnEther
    ) {
        parteUno = _parteUno;
        parteDos = _parteDos;
        descripcion = _descripcion;
        duracionEnDias = _duracionEnDias;
        valorEnWei = _valorEnEther * 1 ether;
        multaEnWei = valorEnWei / 10;
        emit AcuerdoCreado(parteUno, parteDos, _valorEnEther);
        require(parteUno != parteDos); // este requisito es para prevenir poner dos veces la misma direccion volviendo el contrato inutilizable.
    }

    modifier soloParteUno() {
        require(
            msg.sender == parteUno,
            "Solo la parte uno puede realizar esta accion"
        );
        _;
    }

    modifier soloParteDos() {
        require(
            msg.sender == parteDos,
            "Solo la parte dos puede realizar esta accion"
        );
        _;
    }

    function abonarValor() external payable soloParteDos {
        require(
            msg.value == valorEnWei,
            "Debe abonar el valor total del proyecto"
        );
        emit PagoRealizado();
    }

    function entregaDeServicio() external soloParteUno {
        parteUnoEntrego = true;
        emit ServicioEntregado();
    }

    function aprobarServicio() external soloParteDos {
        require(parteUnoEntrego, "La parte uno no ha entregado el servicio");
        parteDosAprobo = true;
        terminado = true;
        payable(parteUno).transfer(valorEnWei);
        emit ServicioAprobado();
    }

    function establecerMulta() external soloParteUno {
        require(!parteDosAprobo, "El servicio ya ha sido aprobado");
        terminado = true;
        payable(msg.sender).transfer(multaEnWei);
    }

    function retirarSaldo() external soloParteUno {
        require(
            parteDosAprobo && terminado,
            "El servicio aun no ha sido aprobado o no se ha establecido la multa"
        );
        payable(msg.sender).transfer(address(this).balance);
    }
    
}
