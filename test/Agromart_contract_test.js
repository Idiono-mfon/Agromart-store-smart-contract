const AgromartContract = artifacts.require("../contracts/AgromartContract.sol");

function strToBase32(string) {
  return web3.utils.asciiToHex(string);
}

function remove_non_ascii(str) {
  if (str === null || str === "") return false;
  else str = str.toString();
  return str.replace(/[^\x20-\x7E]/g, "");
}

function base32ToStr(base32) {
  return remove_non_ascii(web3.utils.hexToAscii(base32));
}

contract("AgromartSmartContract", function (accounts) {
  let contract;
  const sender = accounts[0];

  beforeEach(async function () {
    contract = await AgromartContract.new(
      "Agromart Blockhain Order Details",
      sender,
      {
        // Specify paramters to deploy this
        from: sender,
        gas: 6000000,
      }
    );
  });

  it("contract is initialized", async () => {
    // Check the validity of contract name:
    const contractName = await contract.name.call();
    expect(contractName).to.equal("Agromart Blockhain Order Details");
    // Verify the sender's transaction address.
    const senderAddress = await contract.accessor.call();
    expect(senderAddress).to.equal(sender);
  });

  it("set order details address", async () => {
    await contract.setAddress(
      strToBase32("Abel Okon"),
      strToBase32("Akwa Ibom"),
      strToBase32("Uyo"),
      strToBase32("234567"),
      strToBase32("Ng"),
      {
        from: sender,
      }
    );
    const { reciepientName, line1, city, postalCode, countryCode } =
      await contract.buyerAddress.call();

    expect({
      reciepientName: base32ToStr(reciepientName),
      line1: base32ToStr(line1),
      city: base32ToStr(city),
      postalCode: base32ToStr(postalCode),
      countryCode: base32ToStr(countryCode),
    }).to.deep.equal({
      reciepientName: "Abel Okon",
      line1: "Akwa Ibom",
      city: "Uyo",
      postalCode: "234567",
      countryCode: "Ng",
    });
  });

  // it("Set order details image", async () => {
  //   await contract.setImage(
  //     strToBase32("123456"),
  //     strToBase32("http:hellotest.com"),
  //     {
  //       from: sender,
  //     }
  //   );
  //   const { public_id, url } = await contract.images.call();
  //   expect({
  //     public_id: base32ToStr(public_id),
  //     url: base32ToStr(url),
  //   }).to.deep.equal({
  //     public_id: "123456",
  //     url: "http:hellotest.com",
  //   });
  // });

  it("Set payment details", async () => {
    await contract.setPayment(
      strToBase32("testpaymentid2"),
      strToBase32("Abel Okon"),
      strToBase32("abel@gmail.com"),
      strToBase32("12345678"),
      { from: sender }
    );

    // const rawPayments = await contract.getPayments({
    //   from: sender,
    // });

    // const paymentResults = [];
    // const { 0: paymentId, 1: userName, 2: email, 3: timeStamps } = rawPayments;

    // paymentId.forEach((item, index) => {
    //   const payment = {
    //     paymentId: base32ToStr(paymentId[index]),
    //     username: base32ToStr(userName[index]),
    //     email: base32ToStr(email[index]),
    //     timestamps: base32ToStr(timeStamps[index]),
    //   };

    //   paymentResults.push(payment);
    // });

    //console.log(paymentResults);
    // expect(paymentResults).to.deep.equal([
    //   {
    //     paymentId: "testpaymentid2",
    //     username: "Abel Okon",
    //     email: "abel@gmail.com",
    //     timestamps: "12345678",
    //   },
    // ]);

    // Initial index of product to ne entered to cart
    // const productIndex = await contract.productIndex.call();
    // expect(productIndex.toString()).to.equal("0");
    // Very size of the payment array
  });

  it("set product in cart", async () => {
    // const paymentIndex = await contract.getSize({
    //   from: sender,
    // });
    // expect(paymentIndex.toString()).to.equal("1");
    // Initial index of product to ne entered to cart
    // const productIndex = await contract.productIndex.call();
    // expect(productIndex.toString()).to.equal("1");
    // await contract.setProduct(
    //   true,
    //   2,
    //   strToBase32("1"),
    //   strToBase32("1"),
    //   strToBase32("1"),
    //   strToBase32("1"),
    //   29,
    //   strToBase32("1"),
    //   strToBase32("1"),
    //   3,
    //   strToBase32("1"),
    //   {
    //     from: sender,
    //   }
    // );
    // console.log(res);
  });
});
