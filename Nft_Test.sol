// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Base64.sol";

contract NftTest is ERC721 {
    constructor() ERC721("image_test", "IMT") {

    }
    uint nextTokenId = 0;
    mapping (address => uint[]) images;
    mapping (uint => NftImage) nft_image;

    function add_nft(string memory link, string memory name, string memory description) public {
        _mint(msg.sender, nextTokenId);
        nextTokenId += 1;
        NftImage memory nftImg = NftImage(link, name, description, nextTokenId);
        images[msg.sender].push(nextTokenId);
        nft_image[nextTokenId] = nftImg;
    }

    function tokenURI(uint tokenId) override public view returns(string memory) {
        string memory json = Base64.encode(
            bytes(string(
                abi.encodePacked(
                    '{"name": "', nft_image[tokenId].name, '",',
                    '"image": "', nft_image[tokenId].url, '",',
                    '"description": "', nft_image[tokenId].description, '",',
                    ']}'
                )
            ))
        );
        return string(abi.encodePacked('data:application/json;base64,', json));
    }

    function get_nft(uint tokenId) public view returns(NftImage memory) {
        return nft_image[tokenId];
    }
}

struct NftImage {
    string url;
    string name;
    string description;
    uint tokenId;
}
