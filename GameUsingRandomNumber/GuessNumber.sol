// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./VRFv2Consumer.sol";
import "./EthereumToken.sol";

contract GuessNumberGame {
    // VRFV2 Contract Instance
    VRFv2Consumer vrfConsumer;
    //Eth Token Contrcat Instance
    EthereumToken EthToken;

    uint128 constant public rewardsToken = 100 *10 ** 18;
    uint128 constant public feeToPlay = 100;
    event WinningStatus(uint256 indexed randNumb, address indexed account, string status);
    event VRFaddress(address vrfAddress);

    constructor(address _EthToken , uint64 subcriptionId ) {
        vrfConsumer = VRFv2Consumer(new VRFv2Consumer(subcriptionId));
        EthToken = EthereumToken(_EthToken);
        emit VRFaddress (address(vrfConsumer));
    }
    function guessAndWin(uint256 number) external {
        require(number > 0 && number < 7 , "Invalid Number");
        EthToken.transferFrom(msg.sender, address(this),feeToPlay);
        uint256 randNumb = vrfConsumer.requestRandomWords();
        if(number == randNumb) {
            EthToken.transfer(msg.sender, rewardsToken);
            emit WinningStatus(randNumb, msg.sender, "You have Won");
        }
        
        emit WinningStatus(randNumb, msg.sender, "You have Lose");
    }
}