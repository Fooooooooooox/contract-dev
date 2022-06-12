// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract test {
   struct Book { 
      string title;
      string author;
      uint book_id;
   }
   Book book;

   function setBook() public {
      book = Book('Learn Java', 'TP', 1);
   }
   function getBookId() public view returns (uint) {
      return book.book_id;
   }
}

// notes:
// use book.book_id to fetch parameter value of a struct
// use balances[address] to fetch parameter value of a mapping
