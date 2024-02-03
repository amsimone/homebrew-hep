class Lhapdf < Formula
  include Language::Python::Shebang

  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.5.4.tar.gz"
  sha256 "2443a4b32cc3b0597c8248bd6e25703ace9c91a7a253c5f60b1b5428ef9c869e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://lhapdf.hepforge.org/downloads"
    regex(/href=.*?LHAPDF[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 ventura:  "9bb49ac1a0770fad48aa408344b4d218d302e99401cad6f33549c28264240cdd"
    sha256 monterey: "072b262cf7b118116ee1602ba36f493d4c88296e87dbd7ae0b82b21996c3882a"
  end

  head do
    url "http://lhapdf.hepforge.org/hg/lhapdf", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.10"

  # fix error:
  #   cp: /opt/homebrew/lib/python3.10/site-packages/lhapdf: Operation not permitted
  patch :DATA

  def python
    "python3.10"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", prefix/Language::Python.site_packages(python)

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    rewrite_shebang detected_python_shebang, bin/"lhapdf"
  end

  def caveats
    <<~EOS
      PDFs may be downloaded and installed with

        lhapdf install CT10nlo

      At runtime, LHAPDF searches #{share}/LHAPDF
      and paths in LHAPDF_DATA_PATH for PDF sets.

    EOS
  end

  test do
    system bin/"lhapdf", "--help"
    system Formula["python@3.10"].opt_bin/python, "-c", "import lhapdf"
  end
end

__END__
diff --git a/configure b/configure
index 2723592..1f23030 100755
--- a/configure
+++ b/configure
@@ -18572,7 +18572,7 @@ See \`config.log' for more details" "$LINENO" 5; }



-    PYTHON_PATH=`$PYTHON -c "from __future__ import print_function; import sysconfig; print(sysconfig.get_path('platlib', vars={'platbase': '$prefix', 'base': '$prefix'}))"`
+    PYTHON_PATH=`$PYTHON -c "from __future__ import print_function; import sysconfig; print(sysconfig.get_path('platlib', 'posix_user', vars={'userbase' : '$prefix'}))"`

     { printf "%s\n" "$as_me:${as_lineno-$LINENO}: LHAPDF Python library to be installed to $PYTHON_PATH" >&5
 printf "%s\n" "$as_me: LHAPDF Python library to be installed to $PYTHON_PATH" >&6;}
