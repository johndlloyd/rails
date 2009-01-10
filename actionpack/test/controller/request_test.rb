require 'abstract_unit'

class RequestTest < ActiveSupport::TestCase
  def setup
    ActionController::Base.relative_url_root = nil
    @request = ActionController::TestRequest.new
  end

  def teardown
    ActionController::Base.relative_url_root = nil
  end

  def test_remote_ip
    assert_equal '0.0.0.0', @request.remote_ip

    @request.remote_addr = '1.2.3.4'
    assert_equal '1.2.3.4', @request.remote_ip(true)

    @request.remote_addr = '1.2.3.4,3.4.5.6'
    assert_equal '1.2.3.4', @request.remote_ip(true)

    @request.env['HTTP_CLIENT_IP'] = '2.3.4.5'
    assert_equal '1.2.3.4', @request.remote_ip(true)

    @request.remote_addr = '192.168.0.1'
    assert_equal '2.3.4.5', @request.remote_ip(true)
    @request.env.delete 'HTTP_CLIENT_IP'

    @request.remote_addr = '1.2.3.4'
    @request.env['HTTP_X_FORWARDED_FOR'] = '3.4.5.6'
    assert_equal '1.2.3.4', @request.remote_ip(true)

    @request.remote_addr = '127.0.0.1'
    @request.env['HTTP_X_FORWARDED_FOR'] = '3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = 'unknown,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '172.16.0.1,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '192.168.0.1,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '10.0.0.1,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '10.0.0.1, 10.0.0.1, 3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '127.0.0.1,3.4.5.6'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = 'unknown,192.168.0.1'
    assert_equal 'unknown', @request.remote_ip(true)

    @request.env['HTTP_X_FORWARDED_FOR'] = '9.9.9.9, 3.4.5.6, 10.0.0.1, 172.31.4.4'
    assert_equal '3.4.5.6', @request.remote_ip(true)

    @request.env['HTTP_CLIENT_IP'] = '8.8.8.8'
    e = assert_raises(ActionController::ActionControllerError) {
      @request.remote_ip(true)
    }
    assert_match /IP spoofing attack/, e.message
    assert_match /HTTP_X_FORWARDED_FOR="9.9.9.9, 3.4.5.6, 10.0.0.1, 172.31.4.4"/, e.message
    assert_match /HTTP_CLIENT_IP="8.8.8.8"/, e.message

    # turn IP Spoofing detection off.
    # This is useful for sites that are aimed at non-IP clients.  The typical
    # example is WAP.  Since the cellular network is not IP based, it's a
    # leap of faith to assume that their proxies are ever going to set the
    # HTTP_CLIENT_IP/HTTP_X_FORWARDED_FOR headers properly.
    ActionController::Base.ip_spoofing_check = false
    assert_equal('8.8.8.8', @request.remote_ip(true))
    ActionController::Base.ip_spoofing_check = true

    @request.env['HTTP_X_FORWARDED_FOR'] = '8.8.8.8, 9.9.9.9'
    assert_equal '8.8.8.8', @request.remote_ip(true)

    @request.env.delete 'HTTP_CLIENT_IP'
    @request.env.delete 'HTTP_X_FORWARDED_FOR'
  end

  def test_domains
    @request.host = "www.rubyonrails.org"
    assert_equal "rubyonrails.org", @request.domain

    @request.host = "www.rubyonrails.co.uk"
    assert_equal "rubyonrails.co.uk", @request.domain(2)

    @request.host = "192.168.1.200"
    assert_nil @request.domain

    @request.host = "foo.192.168.1.200"
    assert_nil @request.domain

    @request.host = "192.168.1.200.com"
    assert_equal "200.com", @request.domain

    @request.host = nil
    assert_nil @request.domain
  end

  def test_subdomains
    @request.host = "www.rubyonrails.org"
    assert_equal %w( www ), @request.subdomains

    @request.host = "www.rubyonrails.co.uk"
    assert_equal %w( www ), @request.subdomains(2)

    @request.host = "dev.www.rubyonrails.co.uk"
    assert_equal %w( dev www ), @request.subdomains(2)

    @request.host = "foobar.foobar.com"
    assert_equal %w( foobar ), @request.subdomains

    @request.host = "192.168.1.200"
    assert_equal [], @request.subdomains

    @request.host = "foo.192.168.1.200"
    assert_equal [], @request.subdomains

    @request.host = "192.168.1.200.com"
    assert_equal %w( 192 168 1 ), @request.subdomains

    @request.host = nil
    assert_equal [], @request.subdomains
  end

  def test_port_string
    @request.port = 80
    assert_equal "", @request.port_string

    @request.port = 8080
    assert_equal ":8080", @request.port_string
  end

  def test_request_uri
    @request.env['SERVER_SOFTWARE'] = 'Apache 42.342.3432'

    @request.set_REQUEST_URI "http://www.rubyonrails.org/path/of/some/uri?mapped=1"
    assert_equal "/path/of/some/uri?mapped=1", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    @request.set_REQUEST_URI "http://www.rubyonrails.org/path/of/some/uri"
    assert_equal "/path/of/some/uri", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    @request.set_REQUEST_URI "/path/of/some/uri"
    assert_equal "/path/of/some/uri", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    @request.set_REQUEST_URI "/"
    assert_equal "/", @request.request_uri
    assert_equal "/", @request.path

    @request.set_REQUEST_URI "/?m=b"
    assert_equal "/?m=b", @request.request_uri
    assert_equal "/", @request.path

    @request.set_REQUEST_URI "/"
    @request.env['SCRIPT_NAME'] = "/dispatch.cgi"
    assert_equal "/", @request.request_uri
    assert_equal "/", @request.path

    ActionController::Base.relative_url_root = "/hieraki"
    @request.set_REQUEST_URI "/hieraki/"
    @request.env['SCRIPT_NAME'] = "/hieraki/dispatch.cgi"
    assert_equal "/hieraki/", @request.request_uri
    assert_equal "/", @request.path
    ActionController::Base.relative_url_root = nil

    ActionController::Base.relative_url_root = "/collaboration/hieraki"
    @request.set_REQUEST_URI "/collaboration/hieraki/books/edit/2"
    @request.env['SCRIPT_NAME'] = "/collaboration/hieraki/dispatch.cgi"
    assert_equal "/collaboration/hieraki/books/edit/2", @request.request_uri
    assert_equal "/books/edit/2", @request.path
    ActionController::Base.relative_url_root = nil

    # The following tests are for when REQUEST_URI is not supplied (as in IIS)
    @request.env['PATH_INFO'] = "/path/of/some/uri?mapped=1"
    @request.env['SCRIPT_NAME'] = nil #"/path/dispatch.rb"
    @request.set_REQUEST_URI nil
    assert_equal "/path/of/some/uri?mapped=1", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    ActionController::Base.relative_url_root = '/path'
    @request.env['PATH_INFO'] = "/path/of/some/uri?mapped=1"
    @request.env['SCRIPT_NAME'] = "/path/dispatch.rb"
    @request.set_REQUEST_URI nil
    assert_equal "/path/of/some/uri?mapped=1", @request.request_uri(true)
    assert_equal "/of/some/uri", @request.path(true)
    ActionController::Base.relative_url_root = nil

    @request.env['PATH_INFO'] = "/path/of/some/uri"
    @request.env['SCRIPT_NAME'] = nil
    @request.set_REQUEST_URI nil
    assert_equal "/path/of/some/uri", @request.request_uri
    assert_equal "/path/of/some/uri", @request.path

    @request.env['PATH_INFO'] = "/"
    @request.set_REQUEST_URI nil
    assert_equal "/", @request.request_uri
    assert_equal "/", @request.path

    @request.env['PATH_INFO'] = "/?m=b"
    @request.set_REQUEST_URI nil
    assert_equal "/?m=b", @request.request_uri
    assert_equal "/", @request.path

    @request.env['PATH_INFO'] = "/"
    @request.env['SCRIPT_NAME'] = "/dispatch.cgi"
    @request.set_REQUEST_URI nil
    assert_equal "/", @request.request_uri
    assert_equal "/", @request.path

    ActionController::Base.relative_url_root = '/hieraki'
    @request.env['PATH_INFO'] = "/hieraki/"
    @request.env['SCRIPT_NAME'] = "/hieraki/dispatch.cgi"
    @request.set_REQUEST_URI nil
    assert_equal "/hieraki/", @request.request_uri
    assert_equal "/", @request.path
    ActionController::Base.relative_url_root = nil

    @request.set_REQUEST_URI '/hieraki/dispatch.cgi'
    ActionController::Base.relative_url_root = '/hieraki'
    assert_equal "/dispatch.cgi", @request.path(true)
    ActionController::Base.relative_url_root = nil

    @request.set_REQUEST_URI '/hieraki/dispatch.cgi'
    ActionController::Base.relative_url_root = '/foo'
    assert_equal "/hieraki/dispatch.cgi", @request.path(true)
    ActionController::Base.relative_url_root = nil

    # This test ensures that Rails uses REQUEST_URI over PATH_INFO
    ActionController::Base.relative_url_root = nil
    @request.env['REQUEST_URI'] = "/some/path"
    @request.env['PATH_INFO'] = "/another/path"
    @request.env['SCRIPT_NAME'] = "/dispatch.cgi"
    assert_equal "/some/path", @request.request_uri(true)
    assert_equal "/some/path", @request.path(true)
  end

  def test_host_with_default_port
    @request.host = "rubyonrails.org"
    @request.port = 80
    assert_equal "rubyonrails.org", @request.host_with_port
  end

  def test_host_with_non_default_port
    @request.host = "rubyonrails.org"
    @request.port = 81
    assert_equal "rubyonrails.org:81", @request.host_with_port
  end

  def test_server_software
    assert_equal nil, @request.server_software(true)

    @request.env['SERVER_SOFTWARE'] = 'Apache3.422'
    assert_equal 'apache', @request.server_software(true)

    @request.env['SERVER_SOFTWARE'] = 'lighttpd(1.1.4)'
    assert_equal 'lighttpd', @request.server_software(true)
  end

  def test_xml_http_request
    assert !@request.xml_http_request?
    assert !@request.xhr?

    @request.env['HTTP_X_REQUESTED_WITH'] = "DefinitelyNotAjax1.0"
    assert !@request.xml_http_request?
    assert !@request.xhr?

    @request.env['HTTP_X_REQUESTED_WITH'] = "XMLHttpRequest"
    assert @request.xml_http_request?
    assert @request.xhr?
  end

  def test_reports_ssl
    assert !@request.ssl?
    @request.env['HTTPS'] = 'on'
    assert @request.ssl?
  end

  def test_reports_ssl_when_proxied_via_lighttpd
    assert !@request.ssl?
    @request.env['HTTP_X_FORWARDED_PROTO'] = 'https'
    assert @request.ssl?
  end

  def test_symbolized_request_methods
    [:get, :post, :put, :delete].each do |method|
      self.request_method = method
      assert_equal method, @request.method
    end
  end

  def test_invalid_http_method_raises_exception
    assert_raises(ActionController::UnknownHttpMethod) do
      self.request_method = :random_method
    end
  end

  def test_allow_method_hacking_on_post
    [:get, :head, :options, :put, :post, :delete].each do |method|
      self.request_method = method
      @request.request_method(true)
      assert_equal(method == :head ? :get : method, @request.method)
    end
  end

  def test_invalid_method_hacking_on_post_raises_exception
    assert_raises(ActionController::UnknownHttpMethod) do
      self.request_method = :_random_method
      @request.request_method(true)
    end
  end

  def test_restrict_method_hacking
    @request.instance_eval { @parameters = { :_method => 'put' } }
    [:get, :put, :delete].each do |method|
      self.request_method = method
      assert_equal method, @request.method
    end
  end

  def test_head_masquerading_as_get
    self.request_method = :head
    assert_equal :get, @request.method
    assert @request.get?
    assert @request.head?
  end

  def test_xml_format
    @request.instance_eval { @parameters = { :format => 'xml' } }
    assert_equal Mime::XML, @request.format
  end

  def test_xhtml_format
    @request.instance_eval { @parameters = { :format => 'xhtml' } }
    assert_equal Mime::HTML, @request.format
  end

  def test_txt_format
    @request.instance_eval { @parameters = { :format => 'txt' } }
    assert_equal Mime::TEXT, @request.format
  end

  def test_nil_format
    ActionController::Base.use_accept_header, old =
      false, ActionController::Base.use_accept_header

    @request.instance_eval { @parameters = {} }
    @request.env["HTTP_X_REQUESTED_WITH"] = "XMLHttpRequest"
    assert @request.xhr?
    assert_equal Mime::JS, @request.format

  ensure
    ActionController::Base.use_accept_header = old
  end

  def test_content_type
    @request.env["CONTENT_TYPE"] = "text/html"
    assert_equal Mime::HTML, @request.content_type
  end

  def test_format_assignment_should_set_format
    @request.instance_eval { self.format = :txt }
    assert !@request.format.xml?
    @request.instance_eval { self.format = :xml }
    assert @request.format.xml?
  end

  def test_content_no_type
    assert_equal nil, @request.content_type
  end

  def test_content_type_xml
    @request.env["CONTENT_TYPE"] = "application/xml"
    assert_equal Mime::XML, @request.content_type
  end

  def test_content_type_with_charset
    @request.env["CONTENT_TYPE"] = "application/xml; charset=UTF-8"
    assert_equal Mime::XML, @request.content_type
  end

  def test_user_agent
    assert_not_nil @request.user_agent
  end

  def test_parameters
    @request.stubs(:request_parameters).returns({ "foo" => 1 })
    @request.stubs(:query_parameters).returns({ "bar" => 2 })

    assert_equal({"foo" => 1, "bar" => 2}, @request.parameters)
    assert_equal({"foo" => 1}, @request.request_parameters)
    assert_equal({"bar" => 2}, @request.query_parameters)
  end

  protected
    def request_method=(method)
      @request.env['REQUEST_METHOD'] = method.to_s.upcase
      @request.request_method(true)
    end
end

class UrlEncodedRequestParameterParsingTest < ActiveSupport::TestCase
  def test_unbalanced_query_string_with_array
   assert_equal(
     {'location' => ["1", "2"], 'age_group' => ["2"]},
     ActionController::RequestParser.parse_request_parameters({'location[]' => ["1", "2"], 'age_group[]' => ["2"]})
   )
  end

  def test_request_hash_parsing
    query = {
      "note[viewers][viewer][][type]" => ["User", "Group"],
      "note[viewers][viewer][][id]"   => ["1", "2"]
    }

    expected = { "note" => { "viewers"=>{"viewer"=>[{ "id"=>"1", "type"=>"User"}, {"type"=>"Group", "id"=>"2"} ]} } }

    assert_equal(expected, ActionController::RequestParser.parse_request_parameters(query))
  end

  def test_parse_params
    input = {
      "customers[boston][first][name]" => [ "David" ],
      "customers[boston][first][url]" => [ "http://David" ],
      "customers[boston][second][name]" => [ "Allan" ],
      "customers[boston][second][url]" => [ "http://Allan" ],
      "something_else" => [ "blah" ],
      "something_nil" => [ nil ],
      "something_empty" => [ "" ],
      "products[first]" => [ "Apple Computer" ],
      "products[second]" => [ "Pc" ],
      "" => [ 'Save' ]
    }

    expected_output =  {
      "customers" => {
        "boston" => {
          "first" => {
            "name" => "David",
            "url" => "http://David"
          },
          "second" => {
            "name" => "Allan",
            "url" => "http://Allan"
          }
        }
      },
      "something_else" => "blah",
      "something_empty" => "",
      "something_nil" => "",
      "products" => {
        "first" => "Apple Computer",
        "second" => "Pc"
      }
    }

    assert_equal expected_output, ActionController::RequestParser.parse_request_parameters(input)
  end

  UploadedStringIO = ActionController::UploadedStringIO
  class MockUpload < UploadedStringIO
    def initialize(content_type, original_path, *args)
      self.content_type = content_type
      self.original_path = original_path
      super *args
    end
  end

  def test_parse_params_from_multipart_upload
    file = MockUpload.new('img/jpeg', 'foo.jpg')
    ie_file = MockUpload.new('img/jpeg', 'c:\\Documents and Settings\\foo\\Desktop\\bar.jpg')
    non_file_text_part = MockUpload.new('text/plain', '', 'abc')

    input = {
      "something" => [ UploadedStringIO.new("") ],
      "array_of_stringios" => [[ UploadedStringIO.new("One"), UploadedStringIO.new("Two") ]],
      "mixed_types_array" => [[ UploadedStringIO.new("Three"), "NotStringIO" ]],
      "mixed_types_as_checkboxes[strings][nested]" => [[ file, "String", UploadedStringIO.new("StringIO")]],
      "ie_mixed_types_as_checkboxes[strings][nested]" => [[ ie_file, "String", UploadedStringIO.new("StringIO")]],
      "products[string]" => [ UploadedStringIO.new("Apple Computer") ],
      "products[file]" => [ file ],
      "ie_products[string]" => [ UploadedStringIO.new("Microsoft") ],
      "ie_products[file]" => [ ie_file ],
      "text_part" => [non_file_text_part]
      }

    expected_output =  {
      "something" => "",
      "array_of_stringios" => ["One", "Two"],
      "mixed_types_array" => [ "Three", "NotStringIO" ],
      "mixed_types_as_checkboxes" => {
         "strings" => {
            "nested" => [ file, "String", "StringIO" ]
         },
      },
      "ie_mixed_types_as_checkboxes" => {
         "strings" => {
            "nested" => [ ie_file, "String", "StringIO" ]
         },
      },
      "products" => {
        "string" => "Apple Computer",
        "file" => file
      },
      "ie_products" => {
        "string" => "Microsoft",
        "file" => ie_file
      },
      "text_part" => "abc"
    }

    params = ActionController::RequestParser.parse_request_parameters(input)
    assert_equal expected_output, params

    # Lone filenames are preserved.
    assert_equal 'foo.jpg', params['mixed_types_as_checkboxes']['strings']['nested'].first.original_filename
    assert_equal 'foo.jpg', params['products']['file'].original_filename

    # But full Windows paths are reduced to their basename.
    assert_equal 'bar.jpg', params['ie_mixed_types_as_checkboxes']['strings']['nested'].first.original_filename
    assert_equal 'bar.jpg', params['ie_products']['file'].original_filename
  end

  def test_parse_params_with_file
    input = {
      "customers[boston][first][name]" => [ "David" ],
      "something_else" => [ "blah" ],
      "logo" => [ File.new(File.dirname(__FILE__) + "/rack_test.rb").path ]
    }

    expected_output = {
      "customers" => {
        "boston" => {
          "first" => {
            "name" => "David"
          }
        }
      },
      "something_else" => "blah",
      "logo" => File.new(File.dirname(__FILE__) + "/rack_test.rb").path,
    }

    assert_equal expected_output, ActionController::RequestParser.parse_request_parameters(input)
  end

  def test_parse_params_with_array
    input = { "selected[]" =>  [ "1", "2", "3" ] }

    expected_output = { "selected" => [ "1", "2", "3" ] }

    assert_equal expected_output, ActionController::RequestParser.parse_request_parameters(input)
  end

  def test_parse_params_with_non_alphanumeric_name
    input     = { "a/b[c]" =>  %w(d) }
    expected  = { "a/b" => { "c" => "d" }}
    assert_equal expected, ActionController::RequestParser.parse_request_parameters(input)
  end

  def test_parse_params_with_single_brackets_in_middle
    input     = { "a/b[c]d" =>  %w(e) }
    expected  = { "a/b" => {} }
    assert_equal expected, ActionController::RequestParser.parse_request_parameters(input)
  end

  def test_parse_params_with_separated_brackets
    input     = { "a/b@[c]d[e]" =>  %w(f) }
    expected  = { "a/b@" => { }}
    assert_equal expected, ActionController::RequestParser.parse_request_parameters(input)
  end

  def test_parse_params_with_separated_brackets_and_array
    input     = { "a/b@[c]d[e][]" =>  %w(f) }
    expected  = { "a/b@" => { }}
    assert_equal expected , ActionController::RequestParser.parse_request_parameters(input)
  end

  def test_parse_params_with_unmatched_brackets_and_array
    input     = { "a/b@[c][d[e][]" =>  %w(f) }
    expected  = { "a/b@" => { "c" => { }}}
    assert_equal expected, ActionController::RequestParser.parse_request_parameters(input)
  end

  def test_parse_params_with_nil_key
    input = { nil => nil, "test2" => %w(value1) }
    expected = { "test2" => "value1" }
    assert_equal expected, ActionController::RequestParser.parse_request_parameters(input)
  end

  def test_parse_params_with_array_prefix_and_hashes
    input = { "a[][b][c]" => %w(d) }
    expected = {"a" => [{"b" => {"c" => "d"}}]}
    assert_equal expected, ActionController::RequestParser.parse_request_parameters(input)
  end

  def test_parse_params_with_complex_nesting
    input = { "a[][b][c][][d][]" => %w(e) }
    expected = {"a" => [{"b" => {"c" => [{"d" => ["e"]}]}}]}
    assert_equal expected, ActionController::RequestParser.parse_request_parameters(input)
  end
end
