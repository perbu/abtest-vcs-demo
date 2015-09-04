vcl 4.0;
import std;
import cookie;

backend default {
    .host = "127.0.0.1";
    .port = "8080";
}

sub vcl_recv {

    cookie.parse(req.http.Cookie);

    # Set a UID so we don't rely on GA
    if (cookie.get("uid")) {
       set req.http.uid = cookie.get("uid");
    } else {
      set req.http.uid = std.random(1,1000000);
    }

    if (cookie.get("abgroup")) {
	  std.log("User is already assigned");
	  set req.http.abgroup = cookie.get("abgroup");

	  if (req.http.abgroup !~ "A|B") {
	      # if the user has an invalid value, just force A.
	      std.log("Invalid group. Forcing value...");
	      set req.http.abgroup = "A";
	  }
    } else {
        # 50/50 split for demo purposes
	if (std.random(0, 99) > 50) {
	    # A group
	    set req.http.abgroup = "A";
	} else {
	    # B group
	    set req.http.abgroup = "B";
	}
    }
}

sub vcl_deliver {
    if (req.http.abgroup) {
	set resp.http.Set-Cookie = "abgroup=" + req.http.abgroup +
	    ";uid=" + req.http.uid + "; Expires=" + 
	    cookie.format_rfc1123(now, 10m) + "; httpOnly";

	if (req.url == "/" ) {
		if (req.method == "POST") {
		   # conversion
		   std.log("vcs-key: AB/abconv/" + req.http.abgroup);
		} else {
		   # normal view
		   std.log("vcs-key: AB/abtx/" + req.http.abgroup);
		}
		std.log("vcs-unique-id: " + req.http.uid);

	}
	set resp.http.abgroup = req.http.abgroup;
	set resp.http.uid = req.http.uid;
    }
    unset resp.http.vary;
}
