//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.16;

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom( address sender,address recipient,uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract MAX is IERC20{

    string public name = "MAX";
    string public symbol = "MAX";
    uint public decimals = 0;
    uint public override totalSupply;

    address public founder;
    mapping(address => uint)  balances;
    
    mapping(address => mapping(address => uint)) allowed;


    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address account) public view override returns (uint){
        return balances[account];
    } 

    function transfer(address recipient, uint amount) public override returns (bool){
        require(balances[msg.sender] > amount,"not sufficient balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public override view returns (uint){

        return allowed[owner][spender];
    }

    function approve(address spender, uint amount) public override returns (bool){
        require(balances[msg.sender] >= amount);

        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender, amount);

        return true;
    }

    function transferFrom(address sender,address recipient,uint amount) public override returns (bool){
        require(allowed[sender][recipient] >= amount && amount > 0);
        require(balances[sender] >= amount);

        balances[sender] -= amount;
        balances[recipient] += amount;

        allowed[sender][recipient] -=amount;
        return true;
    }

    function mint(uint _newTokens) external {
        require(msg.sender == founder);

        totalSupply += _newTokens;
        balances[msg.sender] += _newTokens;

        // didnt use function because the address(0) should have tokens to transfer to the founder's address   
        emit Transfer(address(0), msg.sender, _newTokens);
        }

    function burn(uint _burnTokens) public {
        require(_burnTokens <= balances[msg.sender]);

        totalSupply -= _burnTokens;

        transferFrom(msg.sender, address(0), _burnTokens);
    }

}
