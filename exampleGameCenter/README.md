# SETUP FOR BUILDING

To build this example, PhoneGap requires that the plugin be installed in the
correct location relative to this example's www directory.  So we must copy
the plugin JavaScript code to the www directory used by the application.
We must also copy (or reference) the plugin native code and ensure it is
included in the project and build target.

The details of how we do this are as follows:

For native Objective-C code, the Xcode project directly references the native
code using relative path references.  This native code is also included in
target application (so gets linked in at compile time).

For JavaScript code, the XCode project performs the following copy operations
as part of it's pre-build process:

	cp $PROJECT_DIR/../*.js $PROJECT_DIR/www

