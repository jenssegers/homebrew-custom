require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70Redis < AbstractPhp70Extension
  init
  desc "PHP extension for Redis"
  homepage "https://github.com/phpredis/phpredis"
  url "https://github.com/phpredis/phpredis/archive/3.0.0.tar.gz"
  sha256 "030997370bb1906793989c89550d9cafd4fa35dccbad7040b2339301aa961dba"
  head "https://github.com/phpredis/phpredis.git", :branch => "php7"

  bottle do
    cellar :any_skip_relocation
    sha256 "da5969e22977bf776035124fa863e9e7e9e7aa31ceb44393795bcaa761be2806" => :el_capitan
    sha256 "d589330b298a7cfee4bc3de0cc0a2ffb3b72ea0230e8ee2a094380db8588ed5f" => :yosemite
    sha256 "630424900fe5f96805f1b2202002a4188a9a8ae430e54efefcb78902ca47f332" => :mavericks
  end

  def install
    args = []
    args << "--enable-redis-igbinary"

    safe_phpize
    
    mkdir_p "ext/igbinary"
    cp "#{Formula["igbinary"].opt_include}/igbinary.h", "ext/igbinary/igbinary.h"

    system "./configure", "--prefix=#{prefix}", phpconfig, *args
    system "make"

    prefix.install "modules/redis.so"

    write_config_file if build.with? "config-file"
  end

  def config_file
    super + <<-EOS.undent

      ; phpredis can be used to store PHP sessions.
      ; To do this, uncomment and configure below
      ;session.save_handler = redis
      ;session.save_path = "tcp://host1:6379?weight=1, tcp://host2:6379?weight=2&timeout=2.5, tcp://host3:6379?weight=2"
    EOS
  end
end
