// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AgromartContract {

    struct Address {
        bytes32 reciepientName;
        bytes32 line1;
        bytes32 city;
        bytes32 postalCode;
        bytes32 countryCode;
    }
    
    struct Product {
        bytes32 _id;
        bytes32 title;
        uint price;
        uint quantity;
        bytes32 images;
        // Image images;
    }

    struct Payment {
        bytes32 paymentId;
        mapping(uint => Product) cart;
        bytes32 username;
        bytes32 email;
        bytes32 timestamps;
        Address buyerAddress;
    }
    
    string public name; // name of contract;
    address public accessor;
    Address public buyerAddress;
    // Image public images; 
    Payment [] private payments; //payment
    //Store products length for each payments
    uint [] private productSize;
    
    
    modifier isAdmin (address initiatorAddress){
        require(msg.sender == initiatorAddress, "You don't have access to this resource");
        _;
    } 

    constructor  (string memory _name, address _accessor) public {
        name = _name; //name of account;
        accessor = _accessor; //address of user who can authenticate transaction
    }

    function setAddress (
        bytes32 reciepientName, 
        bytes32 line1, 
        bytes32 city, 
        bytes32 postalCode, 
        bytes32 countryCode)
        public isAdmin(accessor) 
        {
            buyerAddress = Address(
                reciepientName, 
                line1, 
                city, 
                postalCode, 
                countryCode
            );
        }
     
     function setPayment(
        bytes32 paymentId,  
        bytes32 username,
        bytes32 email, 
        bytes32 timestamps
        ) public isAdmin(accessor) {
            
        Payment memory payment = Payment(
            paymentId,
            username,
            email,
            timestamps,
            buyerAddress
        );
            //Create product in cart
            // payment.cart[index] = product;
            payments.push(payment);
            
            productSize.length = payments.length;
            // initialize product size array
            productSize[payments.length - 1] = 0;
           

        }
    
    function setProduct (
        bytes32 _id,
        bytes32 title,
        uint price,
        uint quantity,
        bytes32 images
        ) public isAdmin(accessor) 
        {

            require(payments.length > 0, "You have not added any payment.");
            
            Product memory _product = Product(
              _id,
              title,
              price,
              quantity,
              images
            );
           
            Payment storage currPayment = payments[payments.length - 1];
            currPayment.cart[productSize[payments.length - 1]] = _product;
            productSize[payments.length - 1] += 1; //increment index for subsequent products that will be added to cart
        }

        function getPayments () public view returns (bytes32 [] memory, bytes32[] memory, bytes32[] memory, bytes32 [] memory){
            bytes32 [] memory _paymentId = new bytes32 [](payments.length);
        //    bytes32 [] memory _user_id = new bytes32 [](payments.length);
           bytes32 [] memory _name = new bytes32 [](payments.length);
            bytes32 [] memory _email = new bytes32 [](payments.length);
           bytes32 [] memory _timestamps = new bytes32 [](payments.length);
            for (uint i = 0; i < payments.length; i++){
             _paymentId[i] = payments[i].paymentId;
            //  _user_id[i] = payments[i].user_id;
             _name[i] = payments[i].username;
             _email[i] = payments[i].email;
            _timestamps[i] = payments[i].timestamps;
            }

            return (_paymentId, _name, _email, _timestamps);

        }

        function getAllAddress() public view returns (bytes32 [] memory, bytes32 [] memory, bytes32 [] memory, bytes32 [] memory,bytes32 [] memory){
            //  Retrieve all addressess
           bytes32 [] memory _reciepientName = new bytes32 [](payments.length);
           bytes32 [] memory _line1 = new bytes32 [](payments.length);
           bytes32 [] memory _city = new bytes32 [](payments.length);
           bytes32 [] memory _postalCode = new bytes32 [](payments.length);
           bytes32 [] memory _countryCode = new bytes32 [](payments.length);

            for(uint i=0; i < payments.length; i++){
                _reciepientName[i] = payments[i].buyerAddress.reciepientName;
                _line1[i] = payments[i].buyerAddress.line1; 
                _city[i] = payments[i].buyerAddress.city;
                _postalCode[i] = payments[i].buyerAddress.postalCode;
                _countryCode[i] = payments[i].buyerAddress.countryCode;
            }
            return ( _reciepientName, _line1, _city,_postalCode, _countryCode);
         }


        function getProducts (bytes32 paymentId) public view returns (bytes32 [] memory _id, bytes32 [] memory _title, uint [] memory _price, uint [] memory _quantity,bytes32 [] memory _images) {
            
            for (uint i=0; i < payments.length; i++){
                if(paymentId == payments[i].paymentId){
                    // Retrieve the products length previously stored in array
                    uint prodSize = productSize[i];
                    _id = new bytes32 [](prodSize); 
                    _title = new bytes32 [](prodSize); 
                    _price = new uint [](prodSize); 
                    _quantity = new uint [](prodSize); 
                    _images = new bytes32 [](prodSize);
                    // Loop through the product map base on the product length
                    for(uint j = 0; j < prodSize; j++){
                        _id[j] = payments[i].cart[j]._id;
                        _title[j] = payments[i].cart[j].title;
                        _price[j] = payments[i].cart[j].price;
                        _quantity[j] = payments[i].cart[j].quantity;
                        _images[j] = payments[i].cart[j].images;
                    }
                    
                    return(_id, _title, _price, _quantity, _images);

                }

            }

        }

        function getPaymentSize () public view returns (uint ){
            uint res = payments.length;
            return res;
        }

        function getProductsLen () public view returns (uint [] memory) {
            uint [] memory size = productSize;
            return size;
        }


}