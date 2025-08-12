// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {ERC721BatchMintable} from "src/ERC721BatchMintable.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract ERC721BatchMintableTest is Test, ERC721Holder {
  ERC721BatchMintable public instance;

  function setUp() public {
    instance = new ERC721BatchMintable("TestToken", "TEST", "https://example.com/api/token/");
    instance.grantRole(instance.MINTER_ROLE(), address(this));
  }

  function testMetadata() public {
    assertEq(instance.name(), "TestToken");
    assertEq(instance.symbol(), "TEST");
    assertEq(instance.owner(), address(this));
    instance.safeMint(address(this), 1);
    assertEq(instance.tokenURI(0), "https://example.com/api/token/0");
  }

  function testOwnerChange(address newOwner) public {
    instance.setOwner(newOwner);
    assertEq(instance.owner(), newOwner);
  }

  function testBatchMint(uint8 amount) public {
    uint256 initialSupply = instance.totalSupply();
    instance.safeMint(address(this), amount);
    assertEq(instance.totalSupply(), initialSupply + amount);
  }
}
