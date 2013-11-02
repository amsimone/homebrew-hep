require 'formula'

class Yoda < Formula
  homepage 'http://yoda.hepforge.org/'
  url 'http://www.hepforge.org/archive/yoda/YODA-1.0.4.tar.gz'
  sha1 '8077b5de16e6198826014a9e01adc7cbb30df401'

  depends_on :python
  depends_on 'cython' => :python
  depends_on 'boost'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "yoda-config", "--version"
  end
end