backend vejasite {
  .host = "189.91.161.129";
  .port = "80";
  .probe = {
    .request = 
      "GET / HTTP/1.1"
      "Host: veja.abril.com.br"
      "Connection: close";
    .expected_response = 200;
    .interval = 1s;
    .timeout = 30s;
    .threshold = 3;
  }
}

sub vcl_recv {
  if (req.http.host ~ "^(.*)veja.abril.com.br$") {
    set req.backend_hint = vejasite;
  }
}



sub vcl_deliver {
  if (req.backend_hint == vejasite) {
    unset resp.http.X-Varnish;
    unset resp.http.X-Grace;
    unset resp.http.X-Cache-Hits;
    unset resp.http.X-Cache;
    unset resp.http.Server;
    unset resp.http.Via;
  }
}
