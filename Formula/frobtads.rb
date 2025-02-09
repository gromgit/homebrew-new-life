class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "https://www.tads.org/frobtads.htm"
  url "https://github.com/realnc/frobtads/releases/download/v2.0/frobtads-2.0.tar.bz2"
  sha256 "893bd3fd77dfdc8bfe8a96e8d7bfac693da0e4278871f10fe7faa59cc239a090"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/gromgit/new-life"
    sha256 arm64_sonoma: "800761653217d6cb43540195a8920f17d0fa90b8d79561280ad3bb46fc06a448"
    sha256 x86_64_linux: "93e039402cda8004c5def05ee3a7f2b97cbd6f94203069d46e88b82a82bda7aa"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.t").write <<~EOS
      #charset "us-ascii"
      #include <tads.h>

      main(args) {
        "Hello, Homebrew!";
      }
    EOS

    system bin/"t3make", "hello.t"
    system bin/"frob", "--no-pause", "hello.t3"

    assert_match version.to_s, shell_output("#{bin}/frob --version")
  end
end
