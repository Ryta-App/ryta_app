import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/unsplash_image.dart';
import 'package:ryta_app/services/unsplash_image_provider.dart';
import 'package:ryta_app/shared/loading.dart';


/// Screen for showing an individual goal ---> Vusialization
class GoalPage extends StatefulWidget {
  final String imageId, imageUrl;
  
  final Goal goal;
  // GoalPage(this.imageId, this.imageUrl, {Key key}) : super(key: key);
  GoalPage(this.goal, this.imageId, this.imageUrl, {Key key}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

/// Provide a state for [GoalPage].
class _GoalPageState extends State<GoalPage> {

  /// create global key to show info bottom sheet
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // Color maincolor;
  Brightness brightness;

  /// Displayed image.
  UnsplashImage image;

  Color imagemaincolor;


  @override
  Future<void> initState() {
    super.initState();
    // load image
    _loadImage();
    _getColor();
  }
  

  /// Reloads the image from unsplash to get extra data, like: exif, location, ...
  _loadImage() async {
    UnsplashImage image = await UnsplashImageProvider.loadImage(widget.imageId);
    setState(() {
      this.image = image;
    });
  }

  _getColor() async {
    Color imagemaincolor = _getColorFromHex(widget.goal.maincolor);
    Brightness brightness = estimateBrightnessForColor(imagemaincolor);
    setState(() {
      this.brightness = brightness;
      this.imagemaincolor = imagemaincolor;
    });
  }

  /// Returns AppBar.
  Widget _buildAppBar() => AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading:
            // back button
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context)),
      );

  /// Returns PhotoView around given [imageId] & [imageUrl].
  Widget _buildPhotoView(String imageId, String imageUrl) => Hero(
        tag: imageId,
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          initialScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.covered,
          maxScale: PhotoViewComputedScale.covered,
          loadingBuilder: (BuildContext context, ImageChunkEvent imageChunkEvent) {
            return Center(child: Loading(Colors.black));
          },
        ),
      );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // set the global key
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildPhotoView(widget.imageId, widget.imageUrl),
          // wrap in Positioned to not use entire screen
          
          Positioned(top: 0.0, left: 0.0, right: 0.0, child: _buildAppBar()),
          Positioned(bottom: 20.0, right: 20.0, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: brightness == Brightness.dark ? Colors.white54 : Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 180.0,
                    child: Text(
                      widget.goal.goalname,
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: imagemaincolor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  static Brightness estimateBrightnessForColor(Color color) {
  final double relativeLuminance = color.computeLuminance();

  // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
  // The spec says to use kThreshold=0.0525, but Material Design appears to bias
  // more towards using light text than WCAG20 recommends. Material Design spec
  // doesn't say what value to use, but 0.15 seemed close to what the Material
  // Design spec shows for its color palette on
  // <https://material.io/go/design-theming#color-color-palette>.
  const double kThreshold = 0.15;
  if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold)
    return Brightness.light;
  return Brightness.dark;
  }
  Color _getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
}
}

// Why button
          //  IconButton(
          //   icon: Icon(
          //     Icons.info_outline,
          //     color: Colors.white,
          //   ),
          //   tooltip: 'Image Info',
          //   onPressed: () => infoBottomSheetController = _showInfoBottomSheet(),
          // ),