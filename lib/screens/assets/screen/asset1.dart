import 'package:auscurator/components/no_data_animation.dart';
import 'package:auscurator/machine_iot/screens/VideoPlayerScreen.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/machine_iot/widget/shimmer_effect.dart';
import 'package:auscurator/main.dart';
import 'package:auscurator/model/AssetGroupModel.dart';
import 'package:auscurator/provider/asset_provider.dart';
import 'package:auscurator/repository/asset_repository.dart';
import 'package:auscurator/screens/assets/widgets/pdf_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Asset1 extends StatefulWidget {
  const Asset1({super.key});

  @override
  State<Asset1> createState() => _Asset1State();
}

class _Asset1State extends State<Asset1> {
  TextEditingController searchController = TextEditingController();
  List<AssetLists> filteredItems = [];

  // Separate expanded states for asset groups and asset lists
  List<bool> expandedGroupState = [];
  Map<int, List<bool>> expandedAssetState =
      {}; // Map to store expanded state for each asset list

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AssetRepository().getListOfEquipmentGroup(context);
    });
    checkConnection(context);
    searchController.addListener(() {
      filterItems();
    });
    super.initState();
  }

  // Function to launch the URL
  Future<void> launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    // Try to launch the URL
    if (await canLaunchUrl(uri)) {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _showError(context, 'Could not launch $url');
      }
    } else {
      _showError(context, 'Invalid URL: $url');
    }
  }

  // Function to show an error message
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void filterItems() {
    setState(() {}); // Trigger a rebuild to filter in the UI
  }

  void toggleGroupExpansion(int index) {
    setState(() {
      expandedGroupState[index] = !expandedGroupState[index];
    });
  }

  void toggleAssetExpansion(int groupIndex, int assetIndex) {
    setState(() {
      expandedAssetState[groupIndex]![assetIndex] =
          !expandedAssetState[groupIndex]![assetIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetProvider>(
      builder: (context, asset, _) {
        // Apply search filter to the asset group list
        List<AssetGroupLists> assetGroupList =
            asset.assetGroupData?.assetGroupLists ?? [];
        if (searchController.text.isNotEmpty) {
          assetGroupList = assetGroupList.where((asset) {
            return asset.assetGroupName != null &&
                    asset.assetGroupCode!
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()) ||
                asset.assetGroupName!
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
          }).toList();
        }
        // Initialize the expanded state list for asset groups
        if (expandedGroupState.length != assetGroupList.length) {
          expandedGroupState = List.filled(assetGroupList.length, false);
        }

        return ListView(
          // physics: NeverScrollableScrollPhysics(),
          // mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Asset',
                      labelStyle: TextStyle(
                        fontFamily: "Mulish",
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 5),
            asset.isLoading
                ? SingleChildScrollView(
                    child: const Center(
                        child: Padding(
                      padding: EdgeInsets.all(15),
                      child: ShimmerLists(
                        count: 6,
                        width: double.infinity,
                        height: 100,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    )),
                  )
                : assetGroupList.isEmpty
                    ? Center(
                        child: NoDataScreen(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        physics: ClampingScrollPhysics(),
                        itemCount: assetGroupList.length,
                        itemBuilder: (context, groupIndex) {
                          return Column(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => toggleGroupExpansion(groupIndex),
                                child: AnimatedContainer(
                                  padding: const EdgeInsets.all(12.0),
                                  height: expandedGroupState[groupIndex]
                                      ? 340
                                      : 114,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    assetGroupList[groupIndex]
                                                        .assetGroupName
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontFamily: "Mulish",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "${assetGroupList[groupIndex].assetGroupCode.toString()}",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              onTap: () {
                                                toggleGroupExpansion(
                                                    groupIndex);
                                                AssetRepository()
                                                    .getListOfEquipment(context,
                                                        assetGroupId:
                                                            assetGroupList[
                                                                    groupIndex]
                                                                .assetGroupId
                                                                .toString());
                                              },
                                              child: Icon(
                                                expandedGroupState[groupIndex]
                                                    ? Icons.keyboard_arrow_down
                                                    : Icons
                                                        .keyboard_arrow_right,
                                                size: 35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (expandedGroupState[groupIndex])
                                        Consumer<AssetProvider>(
                                          builder: (context, asset1, _) {
                                            // Apply search filter to the asset list
                                            List<AssetLists> assetList = asset
                                                    .assetModelData
                                                    ?.assetLists ??
                                                [];
                                            if (searchController
                                                .text.isNotEmpty) {
                                              assetList = assetList
                                                  .where((asset) =>
                                                      asset.assetCode != null &&
                                                      asset.assetCode!
                                                          .toLowerCase()
                                                          .contains(
                                                              searchController
                                                                  .text
                                                                  .toLowerCase()))
                                                  .toList();
                                            }
                                            // Initialize the expanded state list for each asset group
                                            if (expandedAssetState[
                                                        groupIndex] ==
                                                    null ||
                                                expandedAssetState[groupIndex]!
                                                        .length !=
                                                    assetList.length) {
                                              expandedAssetState[groupIndex] =
                                                  List.filled(
                                                      assetList.length, false);
                                            }
                                            return Expanded(
                                              flex: 2,
                                              child: asset1.isLoading
                                                  ? SingleChildScrollView(
                                                      child: Center(
                                                          child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: ShimmerLists(
                                                            count: 5,
                                                            width:
                                                                double.infinity,
                                                            height: 80),
                                                      )),
                                                    )
                                                  : assetList.isEmpty
                                                      ? Center(
                                                          child: NoDataScreen(),
                                                        )
                                                      : ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              assetList.length,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          itemBuilder: (context,
                                                              assetIndex) {
                                                            return Column(
                                                              children: [
                                                                AnimatedContainer(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          12),
                                                                  height: expandedAssetState[
                                                                              groupIndex]![
                                                                          assetIndex]
                                                                      ? 460
                                                                      : 125,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    boxShadow: const [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey,
                                                                        blurRadius:
                                                                            2,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  child:
                                                                      InkWell(
                                                                    splashFactory:
                                                                        NoSplash
                                                                            .splashFactory,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    onTap: () =>
                                                                        toggleAssetExpansion(
                                                                            groupIndex,
                                                                            assetIndex),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Image.network(
                                                                                        assetList[assetIndex].assetImageUrl ?? 'default_image_url.png', // Replace with a default image URL if necessary
                                                                                        width: 70,
                                                                                        height: 70,
                                                                                        errorBuilder: (context, error, stackTrace) {
                                                                                          return Image.asset('images/machine.jpeg', width: 70, height: 70); // Fallback image in case of error
                                                                                        },
                                                                                      ),
                                                                                      const SizedBox(width: 12),
                                                                                      Expanded(
                                                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                          Text(
                                                                                            assetList[assetIndex].assetName.toString(),
                                                                                            style: TextStyle(
                                                                                              fontFamily: "Mulish",
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Color.fromRGBO(30, 152, 165, 1),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 6),
                                                                                          Text(assetList[assetIndex].assetCode.toString()),
                                                                                          const SizedBox(height: 6),
                                                                                          Text(
                                                                                            "${assetList[assetIndex].location}",
                                                                                            maxLines: 1,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          ),
                                                                                        ]),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                  onTap: () => toggleAssetExpansion(groupIndex, assetIndex),
                                                                                  child: Icon(
                                                                                    expandedAssetState[groupIndex]![assetIndex] ? Icons.arrow_drop_down : Icons.arrow_right,
                                                                                    size: 35,
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                        ),
                                                                        if (expandedAssetState[groupIndex]![
                                                                            assetIndex])
                                                                          Column(
                                                                            children: [
                                                                              Row(children: [
                                                                                // Image Icon - Open asset_image_url
                                                                                IconButton(
                                                                                  onPressed: () {
                                                                                    String imageUrl = assetList[assetIndex].assetImageUrl.toString();
                                                                                    _showImageDialog(context, imageUrl);
                                                                                  },
                                                                                  icon: const Icon(Icons.image_outlined),
                                                                                ),
                                                                                const SizedBox(width: 5.0),

                                                                                // Video Icon - Open asset_video_url
                                                                                IconButton(
                                                                                  onPressed: () {
                                                                                    String videoUrl = assetList[assetIndex].assetVideoUrl.toString();
                                                                                    _showVideoDialog(context, videoUrl);
                                                                                  },
                                                                                  icon: const Icon(Icons.video_camera_back_outlined),
                                                                                ),

                                                                                const SizedBox(width: 5.0),

                                                                                IconButton(
                                                                                  onPressed: () {
                                                                                    // Handle document icon action here if needed
                                                                                    String documentUrl = assetList[assetIndex].assetManualUrl.toString();
                                                                                    // logger.w(documentUrl);
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerScreen(pdfUrl: documentUrl)));
                                                                                  },
                                                                                  icon: const Icon(Icons.document_scanner_outlined),
                                                                                ),

                                                                                const SizedBox(width: 5.0),
                                                                              ]),
                                                                              _expandedListItem(title: 'Asset Group', value: assetList[assetIndex].assetGroup.toString()),
                                                                              const SizedBox(height: 5),
                                                                              _expandedListItem(title: 'Asset Code', value: assetList[assetIndex].assetCode.toString()),
                                                                              const SizedBox(height: 5),
                                                                              _expandedListItem(title: 'Department', value: assetList[assetIndex].department.toString()),
                                                                              const SizedBox(height: 5),
                                                                              _expandedListItem(title: 'Location', value: assetList[assetIndex].location.toString()),
                                                                              const SizedBox(height: 5),
                                                                              _expandedListItem(title: 'Manufacturer', value: assetList[assetIndex].assetManufacturer.toString()),
                                                                              const SizedBox(height: 5),
                                                                              _expandedListItem(title: 'Vendor Name', value: assetList[assetIndex].assetVendorName.toString()),
                                                                              const SizedBox(height: 5),
                                                                              _expandedListItem(title: 'Vendor Contact', value: assetList[assetIndex].assetVendorContact.toString()),
                                                                            ],
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 12),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12)
                            ],
                          );
                        },
                      ),
          ],
        );
      },
    );
  }

  Widget _expandedListItem({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${title}",
                style: TextStyle(
                  fontFamily: "Mulish",
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(30, 152, 165, 1),
                ),
              ),
              Text(
                ":",
                style: TextStyle(
                  fontFamily: "Mulish",
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(30, 152, 165, 1),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            maxLines: 5,
          ),
        ),
      ],
    );
  }

// Function to show the image in a dialog
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Asset Image'),
          content: SizedBox(
            width: double.maxFinite,
            child: Image.network(
                imageUrl), // Use Image.asset if loading from local assets
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

// Function to show the video in a dialog
  void _showVideoDialog(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // Set a fixed height for the video player
            child: VideoPlayerScreen(videoUrl: videoUrl),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
