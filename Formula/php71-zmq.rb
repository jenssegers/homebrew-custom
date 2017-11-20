require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php71Zmq < AbstractPhp71Extension
  init
  desc "ZeroMQ for PHP"
  homepage "http://php.zero.mq/"
  head "https://github.com/mkoppanen/php-zmq.git", :branch => "php7"

  depends_on "pkg-config" => :build
  depends_on "zeromq"

  def install
    ENV.universal_binary if build.universal?

    inreplace "package.xml", "@PACKAGE_VERSION@", version
    inreplace "php-zmq.spec", "@PACKAGE_VERSION@", version
    inreplace "php_zmq.h", "@PACKAGE_VERSION@", version

    safe_phpize
    system "./configure", "--prefix=#{prefix}", phpconfig

    system "make"
    prefix.install "modules/zmq.so"
    write_config_file if build.with? "config-file"
  end
end
