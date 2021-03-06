{ stdenv, fetchFromGitHub, pkgconfig, cmake
, libjpeg ? null
, zlib ? null
, libpng ? null
, eigen ? null
, libtiff ? null
, enableExamples ? false
, enableDocs ? false }:

stdenv.mkDerivation rec {
  version = "1.6";
  pname = "openmvg";

  src = fetchFromGitHub {
    owner = "openmvg";
    repo = "openmvg";
    rev = "v${version}";
    sha256 = "0mrsi0dzgi7cjzn13r9xv7rnc8c9a4h8ip78xy88m9xsyr21wd1h";
    fetchSubmodules = true;
  };

  buildInputs = [ libjpeg zlib libpng eigen libtiff ];

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DOpenMVG_BUILD_EXAMPLES=${if enableExamples then "ON" else "OFF"}"
    "-DOpenMVG_BUILD_DOC=${if enableDocs then "ON" else "OFF"}"
  ];

  cmakeDir = "./src";

  dontUseCmakeBuildDir = true;

  # This can be enabled, but it will exhause virtual memory on most machines.
  enableParallelBuilding = false;

  # Without hardeningDisable, certain flags are passed to the compile that break the build (primarily string format errors)
  hardeningDisable = [ "all" ];

  meta = {
    description = "A library for computer-vision scientists and targeted for the Multiple View Geometry community";
    homepage = "https://openmvg.readthedocs.io/en/latest/";
    license = stdenv.lib.licenses.mpl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ mdaiter ];
  };
}
