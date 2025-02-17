//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.20;

// We import this library to be able to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Token is ERC20, AccessControl {
    using Strings for uint256;
    struct User {
        address addr;
        mapping(string => address) votados;
    }

    enum Voting {
        ON,
        OFF
    }
    Voting public votingStatus;

    address public owner;
    address professora = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    
    bytes32 public constant ADMIN_ROLE  = keccak256("ADMIN_ROLE");
    bytes32 public constant USER_ROLE   = keccak256("USER_ROLE");

    string[18] nomes = [
            'nome1',
            'nome2',
            'nome3',
            'nome4',
            'nome5',
            'nome6',
            'nome7',
            'nome8',
            'nome9',
            'nome10',
            'nome11',
            'nome12',
            'nome13',
            'nome14',
            'nome15',
            'nome16',
            'nome17',
            'nome18'
        ];

    mapping(string => User) public users;
    modifier openVoting() {
        require(votingStatus == Voting.ON, 'Votacao encerrada');
        _;
    }

    event Voted(address indexed voter, address indexed votedAddr, uint256 amount);
    event TokensIssued(address indexed admin, address indexed recipient, uint256 amount);

    constructor() ERC20("saTurings", "SAT") {
        address[18] memory addrs = [
            0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,
            0x90F79bf6EB2c4f870365E785982E1f101E93b906,
            0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65,
            0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,
            0x976EA74026E726554dB657fA54763abd0C3a0aa9,
            0x14dC79964da2C08b23698B3D3cc7Ca32193d9955,
            0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f,
            0xa0Ee7A142d267C1f36714E4a8F75612F20a79720,
            0xBcd4042DE499D14e55001CcbB24a551F3b954096,
            0x71bE63f3384f5fb98995898A86B02Fb2426c5788,
            0xFABB0ac9d68B0B445fB7357272Ff202C5651694a,
            0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec,
            0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097,
            0xcd3B766CCDd6AE721141F452C550Ca635964ce71,
            0x2546BcD3c84621e976D8185a91A922aE77ECEc30,
            0xbDA5747bFD65F08deb54cb465eB87D40e51B197E,
            0xdD2FD4581271e230360230F9337D5c0430Bf44C0,
            0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199
        ];

        owner = msg.sender;
        votingStatus = Voting.ON;

        // ADMIN
        _grantRole(DEFAULT_ADMIN_ROLE, owner);
        _grantRole(ADMIN_ROLE, owner);
        _grantRole(ADMIN_ROLE, professora);

        // USERS
        for(uint i = 0; i < addrs.length; i++){
            users[nomes[i]].addr = addrs[i];
            _grantRole(USER_ROLE, addrs[i]);
        }
    }

    function issueToken(string memory codinome, uint256 amount) public onlyRole(ADMIN_ROLE) {
        require(users[codinome].addr != address(0), "Usuario nao encontrado");
        _mint(users[codinome].addr, amount);
        emit TokensIssued(msg.sender, users[codinome].addr, amount);
    }

    function vote(string memory codinome, uint256 amount) openVoting() public onlyRole(USER_ROLE) {
        require(users[codinome].addr != address(0), 'Este usuario nao existe');     
        require(amount <= 2 * (10 ** 18), 'Valor acima do montante permitido');
        
        require(msg.sender != users[codinome].addr, 'Nao e possivel votar em si mesmo');
        
        string memory codinomeUser = getCodinomeUser(msg.sender);
        require(users[codinomeUser].votados[codinome] == address(0), 'Usuario ja votado');

        users[codinomeUser].votados[codinome] = users[codinome].addr;

        _mint(users[codinome].addr, amount);            
        _mint(msg.sender, 2 * (10 ** 17));            
        
        emit Voted(msg.sender, users[codinome].addr, amount);
    }

    function votingOn() public onlyRole(ADMIN_ROLE) {
        votingStatus = Voting.ON;
    }

    function votingOff() public onlyRole(ADMIN_ROLE) {
        votingStatus = Voting.OFF;
    }

    function isAdmin(address user) public view returns (bool) {
        return hasRole(ADMIN_ROLE, user);
    }

    function getCodinomeUser(address addrSender) public view returns ( string memory ) {
        if (professora == addrSender){
            return "professora";
        }

        for (uint i = 0; i < nomes.length; i++) {
            if (users[nomes[i]].addr == addrSender) {
                return nomes[i];
            }
        }
        revert("Usuario nao encontrado");
    }

    function getUsersWithBalances() public view returns (string[] memory, uint256[] memory) {
        string[] memory codinomes = new string[](nomes.length);
        uint256[] memory balances = new uint256[](nomes.length);

        for (uint i = 0; i < nomes.length; i++) {
            codinomes[i] = nomes[i];
            balances[i]  = balanceOf(users[nomes[i]].addr);
        }
        return (codinomes, balances);
    }
}
