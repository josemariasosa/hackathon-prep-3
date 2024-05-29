const { ethers } = require("hardhat");
const hre = require("hardhat");

console.log("Network: %s", hre.network.name);

const EAS_OP_SEPOLIA_ADDRESS = "0x4200000000000000000000000000000000000021";
const SCHEMAREGISTRY_OP_SEPOLIA_ADDRESS = "0x4200000000000000000000000000000000000020";
const prepResolverSepolia = "0xfF18cAb68c287a08661a529b396DC3fdA2459a49";

async function main() {
  const [deployer, cae1, cae2] = await ethers.getSigners();
  const adminINE = deployer;

  const SchemaRegistry = await ethers.getContractAt("SchemaRegistry", SCHEMAREGISTRY_OP_SEPOLIA_ADDRESS);
  // const EAS = await ethers.getContractAt("EAS", EAS_OP_SEPOLIA_ADDRESS);
  const PrepResolver = await ethers.getContractFactory("PrepResolver");

  // const PrepResolverContract = await PrepResolver.deploy(adminINE.address, EAS_OP_SEPOLIA_ADDRESS);
  // await PrepResolverContract.waitForDeployment();
  const PrepResolverContract = await ethers.getContractAt("PrepResolver", prepResolverSepolia);

  // console.log("resolver: ", PrepResolverContract.target);
  // console.log("PrepResolverContract pan: ", await PrepResolverContract.total)

  console.log("totalPan: ", await PrepResolverContract.totalPan());
  console.log("totalPri: ", await PrepResolverContract.totalPri());
  console.log("totalPrd: ", await PrepResolverContract.totalPrd());
  console.log("totalVerde: ", await PrepResolverContract.totalVerde());
  console.log("totalPt: ", await PrepResolverContract.totalPt());
  console.log("totalMovciu: ", await PrepResolverContract.totalMovciu());
  console.log("totalMorena: ", await PrepResolverContract.totalMorena());
  console.log("totalCi: ", await PrepResolverContract.totalCi());
  console.log("totalPanpriprd: ", await PrepResolverContract.totalPanpriprd());
  console.log("totalPanpri: ", await PrepResolverContract.totalPanpri());
  console.log("totalPanprd: ", await PrepResolverContract.totalPanprd());
  console.log("totalPriprd: ", await PrepResolverContract.totalPriprd());
  console.log("totalVerdeptmorena: ", await PrepResolverContract.totalVerdeptmorena());
  console.log("totalVerdept: ", await PrepResolverContract.totalVerdept());
  console.log("totalVerdemorena: ", await PrepResolverContract.totalVerdemorena());
  console.log("totalPtmorena: ", await PrepResolverContract.totalPtmorena());

  let tx = await PrepResolverContract.connect(adminINE).cargarNuevaCasillas([
    {
      entidad: "Jalisco",
      distrito: "04",
      municipioAlcaldia: "Zapopan",
      seccion: "7969",
      cae: adminINE.address
    },
    {
      entidad: "Jalisco",
      distrito: "04",
      municipioAlcaldia: "Zapopan",
      seccion: "7000",
      cae: "0x21ef41cB6d5a45B8365fd66CBCa85E7dB8eDF311" //brichis
    },
    {
      entidad: "Jalisco",
      distrito: "04",
      municipioAlcaldia: "Zapopan",
      seccion: "79",
      cae: "0x0B438De1DCa9FBa6D14F17c1F0969ECc73C8186F" // jose
    },
    {
      entidad: "Jalisco",
      distrito: "04",
      municipioAlcaldia: "Zapopan",
      seccion: "70",
      cae: "0x1F9E7984eDdb135ab6D6f354E229970bB332dCC4" // teresa
    }
  ]);
  // let res = await tx.wait();
  // // console.log(res);
  // // await PrepResolverContract.cargarFuncionariosCasilla()

  // // const schema = "uint16 pan, uint16 pri, uint16 prd, uint16 verde, uint16 pt, uint16 movciu, uint16 morena, uint16 ci, uint16 panpriprd, uint16 panpri, uint16 panprd, uint16 priprd, uint16 verdeptmorena, uint16 verdept, uint16 verdemorena, uint16 ptmorena, uint16 noregistrado, uint16 nulos";
  // const schema = "uint16 pan, uint16 pri, uint16 prd, uint16 verde, uint16 pt, uint16 movciu, uint16 morena, uint16 ci, uint16 panpriprd, uint16 panpri, uint16 panprd, uint16 priprd, uint16 verdeptmorena, uint16 verdept, uint16 verdemorena, uint16 ptmorena";
  // // const schema = "uint16 pan, uint16 pri, uint16 prd";
  // // const schema = "uint256 pan, uint256 pri, uint256 prd";
  // const resolverAddress = PrepResolverContract.target;
  // const revocable = true;

  // console.log("schema: ", schema);
  // console.log("resolverAddress: ", resolverAddress);
  // console.log("revocable: ", revocable);
  // console.log("version", await SchemaRegistry.version());

  // const transaction = await SchemaRegistry.register(
  //   schema,
  //   resolverAddress,
  //   revocable,
  // );

  // const receipt = await transaction.wait();
  // console.log(receipt);

  // console.log("aca: ", await SchemaRegistry.getSchema("0x7d917fcbc9a29a9705ff9936ffa599500e4fd902e4486bae317414fe967b307c"));
  // console.log("aca: ", await SchemaRegistry.getSchema("0xed247023940bcc84e48c9a74c19eaf4331c9b51dae2e444a1c8dcb11c4bf8faa"));

  // const returnValue = await SchemaRegistry.callStatic.register(schema, resolverAddress, revocable);
  // console.log('Simulated return value:', returnValue);

  // console.log(receipt);
  // const result = receipt.events.find(event => event.event === 'Registered').args.result;
  // console.log('Returned value:', result);

//   struct AttestationRequestData {
//     address recipient; // The recipient of the attestation.
//     uint64 expirationTime; // The time when the attestation expires (Unix timestamp).
//     bool revocable; // Whether the attestation is revocable.
//     bytes32 refUID; // The UID of the related attestation.
//     bytes data; // Custom attestation data.
//     uint256 value; // An explicit ETH amount to send to the resolver. This is important to prevent accidental user errors.
// }

// /// @notice A struct representing the full arguments of the attestation request.
// struct AttestationRequest {
//     bytes32 schema; // The unique identifier of the schema.
//     AttestationRequestData data; // The arguments of the attestation request.
// }

//   let tx = await EAS.connect(cae1).attest(AttestationRequest calldata request);
  
  // // Optional: Wait for transaction to be validated
  // const response = await transaction.wait();

  // console.log(response);
  

//   // Summary
//   console.log("ETHToUSDOracle: ", ADDRESSBOOK[hre.network.name]["ETHToUSDOracleContract"]);
//   console.log("USDTToUSDOracle: ", ADDRESSBOOK[hre.network.name]["USDTToUSDOracleContract"]);
//   console.log("MPETHContract:      ", MPETHContract.target);
//   console.log("USDTContract: ", USDTContract.target);
//   console.log("MPETHPriceFeed:  ", MPETHPriceFeedContract.target);
//   console.log("deployer account:  ", deployer.address);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
