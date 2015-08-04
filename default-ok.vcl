# VCL 4
vcl 4.0;

import std;

# backend veja.abril.com.br
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

acl troubleshooting {
  "127.0.0.1";
}

sub vcl_recv {

  # send veja.abril.com.br to vejasite backend
  if (req.http.host ~ "^(.*)veja.abril.com.br$") {
    set req.backend_hint = vejasite;
  }

  # pass http authentication
  if (req.http.Authorization) {
    return(pass);
  }

  # return pipe for bad http methods
  if (req.method != "GET" &&
      req.method != "HEAD" &&
      req.method != "PUT" && 
      req.method != "POST" &&
      req.method != "TRACE" &&
      req.method != "OPTIONS" &&
      req.method != "PATCH" &&
      req.method != "DELETE") {
    return(pipe);
  }

  # return pass for different methods
  if (req.method != "GET" && req.method != "HEAD") {
    return(pass);
  }

  # normalize accept-encoding
  if (req.http.Accept-Encoding) {
    if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)") {
      unset req.http.Accept-Encoding;
    }
  } elseif (req.http.Accept-Encoding ~ "gzip") {
    set req.http.Accept-Encoding = "gzip";
  } elseif (req.http.Accept-Encoding ~ "deflate") {
    set req.http.Accept-Encoding = "deflate";
  } else {
    unset req.http.Accept-Encoding;
  }

  # normalize google-analytics requests
  set req.http.Cookie = regsuball(req.http.Cookie, "__utm.=[^;]+(; )?",  "");
  set req.http.Cookie = regsuball(req.http.Cookie, "_ga.=[^;]+(; )?",    "");
  set req.http.Cookie = regsuball(req.http.Cookie, "utmctr.=[^;]+(; )?", "");
  set req.http.Cookie = regsuball(req.http.Cookie, "utmcmd.=[^;]+(; )?", "");
  set req.http.Cookie = regsuball(req.http.Cookie, "utmcnn.=[^;]+(; )?", "");

  # return default hash for all requests
  return(hash);

}

sub vcl_backend_response {

  # auto cache-control config for bad fingers
  if (!beresp.http.Cache-Control) {
    set beresp.http.Cache-Control = "max-age=120, forced";
    set beresp.ttl = 120s;
  }

  # set default grace time
  set beresp.grace = 24h;
}

sub vcl_deliver {

  if (client.ip ~ troubleshooting) {
     #configure headers for deliver infos about varnish
    if (obj.hits > 0) {
      set resp.http.X-Varnish-Cache = "HIT";
    } else {
      set resp.http.X-Varnish-Cache = "MISS";
    }
    set resp.http.X-Varnish-Cache-Hits = obj.hits;
    set resp.http.X-Varnish-Grace = req.http.X-Varnish-Grace;
  }

  unset resp.http.X-Varnish;
  unset resp.http.X-Grace;
  unset resp.http.X-Cache-Hits;
  unset resp.http.X-Cache;
  unset resp.http.Server;
  unset resp.http.Via;

}

sub vcl_hit {

  if (!std.healthy(req.backend_hint)) {
    set req.http.X-Varnish-Grace = "Grace On - Time: " + (obj.ttl);
  } else {
    set req.http.X-Varnish-Grace = "Grace Off";
  }
}


