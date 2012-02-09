#!/usr/bin/ruby
#
# Copyright (c) 2010, Polycom, Inc.
#
# Author: Edward Estabrook <edward.estabrook@polycom.com>
#


require 'test/unit'
require './sipp_test'

class IncludeDirectory < Test::Unit::TestCase
  def test_include_substitution
    test = SippTest.new("include_substitution", "-sf include_substitution.sipp -mc -dump_xml -skip_rlimit")
	
    test.expected_client_output = %Q!<?xml version="1.0" encoding="ISO-8859-1" ?>\n<\!DOCTYPE scenario SYSTEM "sipp.dtd">\n\n<scenario name="include_substitution" parameters="-mc" xmlns:xi="http://www.w3.org/2001/XInclude">\n\n  <\!-- include file in current sub-directory, replacement is aA=>1, Bb=>4, cc=>2 -->\n  <?xml version="1.0" encoding="ISO-8859-1" ?>\n<\!DOCTYPE scenario SYSTEM "sipp.dtd">\n<scenario name="Include Substitution 1" parameters="-mc" xmlns:xi="http://www.w3.org/2001/XInclude">\n\n  <\!-- include_substitution_1 file has directly specified parameters -->\n   <?xml version="1.0" encoding="ISO-8859-1" ?>\n<\!DOCTYPE scenario SYSTEM "sipp.dtd">\n\n<scenario name="Include Substitution 2" parameters="-mc" xmlns:xi="http://www.w3.org/2001/XInclude">\n\n  <\!-- include_substitution_2 file in sub-directory, inherits substitution -->\n  \n  <send dialog="04">\n   <\![CDATA[\n      INVITE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      Content-Length: [len]\n    ]]>\n  </send>\n\n  <send dialog="01">\n   <\![CDATA[\n      BYE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      cseq: [cseq dialog="04"]\n      Content-Length: [len]\n    ]]>\n  </send>\n  \n</scenario> \n  \n  <send dialog="01">\n   <\![CDATA[\n      INVITE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      Content-Length: [len]\n    ]]>\n  </send>\n\n  <send dialog="04">\n   <\![CDATA[\n      BYE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      cseq: [cseq dialog="01"]\n      Content-Length: [len]\n    ]]>\n  </send>\n  \n  <send dialog="02">\n   <\![CDATA[\n      SUBSCRIBE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      Content-Length: [len]\n    ]]>\n  </send>\n  \n</scenario>\n  \n  <\!-- include file in current sub-directory, replacement is aA=>99, Bb=>1, cc=>3 -->\n  <?xml version="1.0" encoding="ISO-8859-1" ?>\n<\!DOCTYPE scenario SYSTEM "sipp.dtd">\n<scenario name="Include Substitution 1" parameters="-mc" xmlns:xi="http://www.w3.org/2001/XInclude">\n\n  <\!-- include_substitution_1 file has directly specified parameters -->\n   <?xml version="1.0" encoding="ISO-8859-1" ?>\n<\!DOCTYPE scenario SYSTEM "sipp.dtd">\n\n<scenario name="Include Substitution 2" parameters="-mc" xmlns:xi="http://www.w3.org/2001/XInclude">\n\n  <\!-- include_substitution_2 file in sub-directory, inherits substitution -->\n  \n  <send dialog="01">\n   <\![CDATA[\n      INVITE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      Content-Length: [len]\n    ]]>\n  </send>\n\n  <send dialog="99">\n   <\![CDATA[\n      BYE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      cseq: [cseq dialog="01"]\n      Content-Length: [len]\n    ]]>\n  </send>\n  \n</scenario> \n  \n  <send dialog="99">\n   <\![CDATA[\n      INVITE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      Content-Length: [len]\n    ]]>\n  </send>\n\n  <send dialog="01">\n   <\![CDATA[\n      BYE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      cseq: [cseq dialog="99"]\n      Content-Length: [len]\n    ]]>\n  </send>\n  \n  <send dialog="03">\n   <\![CDATA[\n      SUBSCRIBE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      Content-Length: [len]\n    ]]>\n  </send>\n  \n</scenario>\n\n</scenario>\n\n\n!
    assert(test.run())
  end


  def test_include_substitution_sequence_diagram
    test = SippTest.new("include_substitution_sequence_diagram", "-sf include_substitution.sipp -mc -dump_sequence_diagram -skip_rlimit")
	
    test.expected_client_output = %Q!      INVITE(4 ) ----------> \r\n         BYE(1 ) ----------> \r\n      INVITE(1 ) ----------> \r\n         BYE(4 ) ----------> \r\n   SUBSCRIBE(2 ) ----------> \r\n      INVITE(1 ) ----------> \r\n         BYE(99) ----------> \r\n      INVITE(99) ----------> \r\n         BYE(1 ) ----------> \r\n   SUBSCRIBE(3 ) ----------> \r\n!
    assert(test.run())
  end

    # xml commented out first include from include_substitution.sipp and verify file is not included, allow second substitution to complete
  def test_commented_include_substitution
    test = SippTest.new("test_commented_include_substitution", "-sf commented_include_substitution.sipp -mc -dump_xml -skip_rlimit")
    #test.logging="verbose"
    test.expected_client_output = %Q!<?xml version="1.0" encoding="ISO-8859-1" ?>\n<\!DOCTYPE scenario SYSTEM "sipp.dtd">\n\n<scenario name="include_substitution" parameters="-mc" xmlns:xi="http://www.w3.org/2001/XInclude">\n\n  <\!-- include file in current sub-directory, replacement is aA=>1, Bb=>4, cc=>2 -->\n<\!--  <xi:include href="include_substitution_1.xml" dialogs="1,4,2" /> -->:\n  \n  <\!-- include file in current sub-directory, replacement is aA=>99, Bb=>1, cc=>3 -->\n  <?xml version="1.0" encoding="ISO-8859-1" ?>\n<\!DOCTYPE scenario SYSTEM "sipp.dtd">\n<scenario name="Include Substitution 1" parameters="-mc" xmlns:xi="http://www.w3.org/2001/XInclude">\n\n  <\!-- include_substitution_1 file has directly specified parameters -->\n   <?xml version="1.0" encoding="ISO-8859-1" ?>\n<\!DOCTYPE scenario SYSTEM "sipp.dtd">\n\n<scenario name="Include Substitution 2" parameters="-mc" xmlns:xi="http://www.w3.org/2001/XInclude">\n\n  <\!-- include_substitution_2 file in sub-directory, inherits substitution -->\n  \n  <send dialog="01">\n   <\![CDATA[\n      INVITE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      Content-Length: [len]\n    ]]>\n  </send>\n\n  <send dialog="99">\n   <\![CDATA[\n      BYE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      cseq: [cseq dialog="01"]\n      Content-Length: [len]\n    ]]>\n  </send>\n  \n</scenario> \n  \n  <send dialog="99">\n   <\![CDATA[\n      INVITE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      Content-Length: [len]\n    ]]>\n  </send>\n\n  <send dialog="01">\n   <\![CDATA[\n      BYE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      cseq: [cseq dialog="99"]\n      Content-Length: [len]\n    ]]>\n  </send>\n  \n  <send dialog="03">\n   <\![CDATA[\n      SUBSCRIBE sip:[service]@[remote_ip]:[remote_port] SIP/2.0\n      Content-Length: [len]\n    ]]>\n  </send>\n  \n</scenario>\n\n</scenario>\n\n\n!
    assert(test.run())
  end

end
