// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./GoldRate.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./USDC.sol";

contract UniqueGoldtoken is ERC20 {
    GoldRate private goldRate;
    USDC private usdc;
    //Events
    event BuyToken(address indexed caller, address indexed to , uint256 amountPaid , uint256 boughtTokens );
    constructor(address _goldRate , address _usdc) ERC20("UniqueGoldtoken", "UGT") {
        goldRate = GoldRate(_goldRate);
        usdc = USDC(_usdc);
    }

    function buyToken(address to , uint256 _amountToPay) external {
        require(_amountToPay > 0, "invaid amount");
        uint256 pricePerGram = uint256(goldRate.oneGramGoldPrice()) / 100; // 1 g gold price in USD (8D to 6D)
        uint256 tokensTotransfer = ( _amountToPay * 1e8) / pricePerGram;  // as mintToken has 8 decimals so 1e8
        usdc.transferFrom(msg.sender,address(this) , _amountToPay);
        _mint(to, tokensTotransfer);
        emit BuyToken(msg.sender,to, _amountToPay,tokensTotransfer);
    }

    function decimals() public pure  override returns (uint8) {
        return 8;
    }
}
   

