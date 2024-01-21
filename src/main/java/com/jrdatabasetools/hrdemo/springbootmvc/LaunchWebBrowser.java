/*
 * Thanks to kasramp (https://gist.github.com/kasramp)
 * https://gist.github.com/kasramp/2b9e04ccc1b65e087440828810c3bb4b#file-simpleurlbrowser-java
 */

package com.jrdatabasetools.hrdemo.springbootmvc;

import java.io.IOException;
import java.lang.invoke.MethodHandles;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LaunchWebBrowser {
  private static final Logger   logger   = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

  private static final String[] browsers = { "google-chrome", "firefox", "mozilla", "epiphany", "konqueror", "netscape",
                                             "opera", "links", "lynx", "chromium", "brave-browser" };

  public static void browse(String url) {
    try {
      if (isMacOperatingSystem()) {
        openUrlInDefaultMacOsBrowser(url);
      }
      else if (isWindowsOperatingSystem()) {
        openUrlInDefaultWindowsBrowser(url);
      }
      else {
        openUrlInDefaultUnixBrowser(url);
      }
    }
    catch (Exception ex) {
      logger.warn("unable to open local browser url : " + url + " => cause : " + ex.getMessage());
    }
  }

  private static boolean isMacOperatingSystem() {
    return getOperatingSystemName().startsWith("Mac OS");
  }

  private static boolean isWindowsOperatingSystem() {
    return getOperatingSystemName().startsWith("Windows");
  }

  private static String getOperatingSystemName() {
    return System.getProperty("os.name");
  }

  private static void openUrlInDefaultMacOsBrowser(String url) throws IOException {
    System.out.println("Attempting to open that address in the default browser now...");
    Runtime.getRuntime().exec(new String[] { "open", url });
  }

  private static void openUrlInDefaultWindowsBrowser(String url) throws IOException {
    System.out.println("Attempting to open that address in the default browser now...");
    Runtime.getRuntime().exec(new String[] { "rundll32", String.format("url.dll,FileProtocolHandler %s", url) });
  }

  private static void openUrlInDefaultUnixBrowser(String url) throws Exception {
    String browser = null;
    for (String b : browsers) {
      if (browser == null && Runtime.getRuntime().exec(new String[] { "which", b }).getInputStream().read() != -1) {
        System.out.println("Attempting to open that address in the default browser now...");
        Runtime.getRuntime().exec(new String[] { browser = b, url });
      }
    }
    if (browser == null) {
      throw new Exception("No web browser found");
    }
  }
}
