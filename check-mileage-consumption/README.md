# Check Milleage

## Overview
* The task registers the user using the function **addUser**.
* Once the user is registered, enter the mileage and ticket price details using the function **addMileage**.
* User gets discount, when their total mileage and ticket price reaches 10000 and 20000 consicutively.
* User can check the discounted ticket price using the fuction **checkDiscountPrice**.
* Users can check their details such as total mileage, total ticket price and discount available using the function **getUserDetails**.

## Functions
1. `addUser()` reigsters user with unique id and its address.
2. `addMileage()` adds mileage and ticket price details.
3. `getUserDetails()` returns user details of specified unique ID.
4. `checkDiscountPrice()` returns discounted ticket price if user has any discount.
5. `getOwner()` returns the address of the contracts owner.

## Modifiers
1. `isOwner()` modifier checks contract caller address matches contract owner address.
2. `isUser()` modifier checks contract caller address matches the address mapped with provided userID.

## Event
1. `discount`event emits when the user reaches the specfied discount criteria.


> The contract has been deployed on Ropsten Test Network with contract address **0x60CcFb47482AD98085d66D7f5c55BcaE05885e76**.
