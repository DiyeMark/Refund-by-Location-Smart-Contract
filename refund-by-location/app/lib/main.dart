import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  late Client httpClient;

  late Web3Client ethClient;

  //Ethereum address
  final String myAddress = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";

  //url from Infura
  final String blockchainUrl =
      "https://rinkeby.infura.io/v3/8014b5129eb945eba4b0efd04c78650e";

  @override
  void initState() {
    checkGps();
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }

  Future<DeployedContract> getContract() async {
    String abiFile = await rootBundle
        .loadString("contracts/build/contracts/RefundByLocation.json");
    String contractAddress = "";
    final contract = DeployedContract(
        ContractAbi.fromJson(abiFile, "RefundByLocation"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> callFunction(String name, List params) async {
    final contract = await getContract();
    final function = contract.function(name);
    final result = await ethClient.call(
        contract: contract, function: function, params: params);
    return result;
  }

  Future<void> reportLocation() async {
    await callFunction(
        'reportLocation', [lat, long, DateTime.now().millisecondsSinceEpoch]);
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(hours: 1), (Timer t) => reportLocation());
    return Scaffold(
        appBar: AppBar(
            title: const Text("Get GPS Location"),
            backgroundColor: Colors.redAccent),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50),
            child: Column(children: [
              Text(servicestatus ? "GPS is Enabled" : "GPS is disabled."),
              Text(haspermission ? "GPS is Enabled" : "GPS is disabled."),
              Text("Longitude: $long", style: const TextStyle(fontSize: 20)),
              Text(
                "Latitude: $lat",
                style: const TextStyle(fontSize: 20),
              )
            ])));
  }
}
