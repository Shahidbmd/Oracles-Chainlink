pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract GoldRate {
  AggregatorV3Interface public priceFeed;
   // Sepolia Network AUX/USD
  constructor() {
    priceFeed = AggregatorV3Interface(0xC5981F461d74c46eB4b0CF3f4Ec79f025573B0Ea);
  }

  function TEGramGoldPrice() public view returns (int256) {
    (,int256 price,,,) = priceFeed.latestRoundData();
    return price;
  }
  function oneGramGoldPrice() public view returns (int256) {
    (,int256 price,,,) = priceFeed.latestRoundData();
    int256 oneGramPrice = _calculateRates(price);
    return oneGramPrice;
  }

  function getDecimals() public view returns (uint8) {
    uint8 decimals = priceFeed.decimals();
    return decimals;
  }

  function _calculateRates(int256 price) private pure returns(int256) {
      int256 oneGramPrice = price *10000 / 283495 ; // 1 ounce = 28.3495 g
      return oneGramPrice ; // 1 gram price 
  }
}
