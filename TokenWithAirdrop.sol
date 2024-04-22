pragma solidity ^0.8.24;


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);
}


contract ERC20 is IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner, address indexed spender, uint256 value
    );

     event AirdropSuccess(address indexed recipient, uint256 amount);

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name;
    string public symbol;
    uint8 public decimals;

    // List to store hashed values
    bytes32[] private airdropHashList;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        // Populate the airdropHashList with example hash values
        airdropHashList.push(0x006873DFD89C62CF4BD361267FD0BF3F4F8D90EA689941DF0059086F965FF3D5);
        airdropHashList.push(0x5BFB7176F1F7A1168B0286E21CCD99F2BAE91FAA92B0CD2C550517FE76E2C589);
        airdropHashList.push(0x61C8DD88F67B7E4DFEA68A0C80936138D1D77B75D4069214F07FD0BE95A64323);
        airdropHashList.push(0x7C79FFB347E71EDCD9D0C0511C7F58C1E0C3BCBCF3ED5E8F2842FA27FD947512);
        airdropHashList.push(0x9DE12DBFB3B61BFF1BCFDC7D319EC887E35AFB24343496BBA6BDE17EB4AB65A1);
        airdropHashList.push(0x41D8B6B7979B0A5DFE949AF780F0DE97B2A12F242853556B33A4E4F611B84123);

    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    //our unique function!
    function airdrop(string memory input) external{
        bytes32 hashedInput = sha256(bytes(input));
        bool validInput = false;
    // Check if the hashed input matches any hash in the list
        for (uint256 i = 0; i < airdropHashList.length; i++) {
            if (hashedInput == airdropHashList[i]) {
                // Mint a token and give it to the person who called the method
                _mint(msg.sender, 1);

                // Remove the used hash from the list (set equal to the last item and then remove the last item)
                airdropHashList[i] = airdropHashList[airdropHashList.length - 1];
                airdropHashList.pop();

                validInput = true;
                emit AirdropSuccess(msg.sender, 1);
                break; // Exit the loop once a match is found
            }
        }
        // If no match is found, fail the transaction
        if(validInput == false){
            revert("Invalid airdrop hash");
        }
       
        
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }


    

    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool)
    {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        balanceOf[from] -= amount;
        totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}
