// JavaScript Document

browser_is_ff = ((!/msie/i.test(navigator.userAgent) && !/opera/i.test(navigator.userAgent) && !/Netscape/i.test(navigator.userAgent)) && /Gecko/i.test(navigator.userAgent) && /Firefox/i.test(navigator.userAgent));
browser_is_ie = (/msie/i.test(navigator.userAgent) && !/opera/i.test(navigator.userAgent) && !/Gecko/i.test(navigator.userAgent) && !/Netscape/i.test(navigator.userAgent) && !/Firefox/i.test(navigator.userAgent) );
browser_is_ns = ((!/msie/i.test(navigator.userAgent) && !/opera/i.test(navigator.userAgent) && !/Firefox/i.test(navigator.userAgent)) && /Gecko/i.test(navigator.userAgent) && /Netscape/i.test(navigator.userAgent));
browser_is_op = ((!/msie/i.test(navigator.userAgent) && /opera/i.test(navigator.userAgent) && !/Firefox/i.test(navigator.userAgent) && !/Gecko/i.test(navigator.userAgent) && !/Netscape/i.test(navigator.userAgent)));
