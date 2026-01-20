// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

// original: imp-ort "./../contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Pausabled is Ownable{

    bool internal _paused;
    
    
    modifier Active() {
         require( !isPaused() ," Error is paused!");
        _;
    }

  
    function isPaused() public view returns(bool){
        return _paused;
    }
    
    
    event Paused(bool paused);
    function setPause(bool paused) public onlyOwner returns(bool){
        _paused=paused;
        emit Paused(_paused);
        return true;
    }
    
    
    
}




