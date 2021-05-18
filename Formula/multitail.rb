class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://web.archive.org/web/20210322212714/www.vanheusden.com/multitail/"
  url "https://deb.debian.org/debian/pool/main/m/multitail/multitail_6.5.0.orig.tar.gz"
  sha256 "b29d5e77dfc663c7500f78da67de5d82d35d9417a4741a89a18ce9ee7bdba9ed"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-new-life/releases/download/multitail-6.5.0"
    sha256 cellar: :any,                 big_sur:      "63c58d62f56420d226b576d530142471d54067fdb3fc4c71b4889b00e1501449"
    sha256 cellar: :any,                 catalina:     "c6b37d0c8d3217a1fcc4d79a48c555af01209d83b78510f026490274b5fe58e3"
    sha256 cellar: :any,                 mojave:       "f4ef1c44131cea1677f591344e09d96459919d103576fb41f801682296cd629d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "acfa846598c4840ae4798c5b9af3dfb6ee950158638125a55e8dd7b595cfe311"
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    makeargs = []
    makeargs = %w[-f makefile.macosx] if OS.mac?
    system "make", *makeargs, "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}/multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
    end
  end
end
