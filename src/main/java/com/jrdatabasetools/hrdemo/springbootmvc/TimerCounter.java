/*
 * Copyright (c) jr-database-tools GmbH, Switzerland, 2015-2025. All rights reserved.
 */

package com.jrdatabasetools.hrdemo.springbootmvc;

public class TimerCounter {
  private long start;
  private long pause;

  public TimerCounter() {
    preset();
  }

  public String diff(String what) {
    return what + " " + diff();
  }

  public String diff() {
    long diff = 0;
    if (pause < 0) {
      diff = System.currentTimeMillis() - start;
    }
    else {
      diff = pause - start;
    }

    preset();

    return String.format("[%s]", toTimeString(diff));
  }

  public String perSecond(String what, int count) {
    return what + " " + perSecond(count);
  }

  public String perSecond(int count) {
    long diff = System.currentTimeMillis() - start;
    preset();
    return String.format("[count:%d] [%1.0f per second] [%s]", count, 1. / diff * 1000L * count, toTimeString(diff));
  }

  private String toTimeString(long diff) {
    return String.format("%02d:%02d:%02d.%03d", (diff / 3600000), (diff / 60000) % 60, (diff / 1000) % 60, diff % 1000);
  }

  public void preset() {
    start = System.currentTimeMillis();
    pause = -1;
  }

  public void pause() {
    pause = System.currentTimeMillis();
  }

  public void resume() {
    if (pause > 0) {
      start += System.currentTimeMillis() - pause;
      pause = -1;
    }
  }

  public void restart() {
    start = System.currentTimeMillis();
    pause = -1;
  }
}
