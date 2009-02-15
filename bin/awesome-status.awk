#!/bin/awk -f

# Version 0.3
# Change: MPD_MSG added
# Change: I removed the SLEEP_ALLOWS_FLOATS config option. Just set your interval to 
# INTERVAL, and that will be taken...
#
# cpu_total, cpu_user and cpu_nice are now the new variables with the cpu infos
#
# When you run this script itself, keep pressing on <C-c> for some time to kill it,
# or: killall awesome-status.awk
#
# feel free to send me enhancements etc... (awesome mailing list, wiki, or mac at calmar.ws)

#EDIT below <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

BEGIN {
  #DATE_CMD = "LANG=de_CH date +\"%X %a, %e %b\"";
  DATE_CMD = "date +\"%X %a, %e %b\"";

  INTERVAL = 0.992;        # in seconds (note not all 'sleep' allow floats!, use an iteger then).
                           # somebit less than a second, because the script takes some time itself.
                           # finally it updates the values each second with that value on my pc.

  #MAILBOX_FILE = "/home/calmar/.mail/inbox"; # must be a mbox format.
  #MAIL_INTERVAL = 20;      # multiply of normal interval (this check can be hard on resources, that's why)

  DF_INTERVAL = 1;         # not necessary to call 'df + args' more often, for my taste at least
  DF_CMD = "df /dev/sda12 /dev/sda13 /dev/sda8"
  DF_RANGE = 80            # show values from x to 100 percent only.
                           # (so that the empty space is more visible on the graph)

  # set to 0, if no need for it. Use lowercase items in print_data()
  
  DATE_STR = 1;            # date string according to DATE_CMD
  ETH_IN_KBS = 1;          # incoming traffic kb/s (about)
  ETH_OUT_KBS = 1;         # outgoing traffic kb/s (about)
  MEM_PERCENT = 1;         # used mem in percent
  SWAP_PERCENT = 1;        # used swap space in percent
  CPU_TOTAL = 1;           # CPU in percent (total)
  CPU_USER = 1;            # CPU in percent (user usage)
  CPU_NICE = 1;            # CPU in percent (nice processes)
  MAILBOX_COUNT = 1;       # check a mailbox (mbox format)
  DF_1_PERCENT = 1;        # check used/free space
  MPD_MSG = 0;             # MPD playing info
}

# edit according to the ~/.awesomerc setup (names of widgets...)
# NOTE: awk directly joins strings separated by any whitespaces.

function print_data()
{
  print "0 widget_tell sbtop gr_cpu data total "  cpu_total;
  print "0 widget_tell sbtop gr_cpu data user "   cpu_user;
  print "0 widget_tell sbtop gr_cpu data nice "   cpu_nice;
  print "0 widget_tell sbtop tb_net_in text "     eth_in_kbs;
  print "0 widget_tell sbtop tb_net_out text "    eth_out_kbs;
  print "0 widget_tell sbtop gr_net data in "     eth_in_kbs;
  print "0 widget_tell sbtop gr_net data out "    eth_out_kbs;
  print "0 widget_tell sbtop pb_mem data mem "    mem_percent;
  print "0 widget_tell sbtop pb_mem data swap "   swap_percent;
  print "0 widget_tell sbtop pb_df_1 data root "  df_1_percent[0];
  print "0 widget_tell sbtop pb_df_1 data home "  df_1_percent[1];
  print "0 widget_tell sbtop pb_df_1 data multi " df_1_percent[2];
  print "0 widget_tell sbtop tb_date text "       date_str " ";
  #print "0 widget_tell sbtop tb_mail text "       mailbox_count;

   blinking stuff
  if (df_1_percent_blink[0])
  { 
    print "0 widget_tell pb_df_1 bordercolor root #4444cc"; df_1_percent_blink[0] = 0;
  }
  else if (df_1_percent[0] > 30)
  {
    print "0 widget_tell pb_df_1 bordercolor root #ff0000"; df_1_percent_blink[0] = 1;
  }

  if (df_1_percent_blink[1])
  { 
    print "0 widget_tell pb_df_1 bordercolor home #336633"; df_1_percent_blink[1] = 0;
  }
  else if (df_1_percent[1] > 80)
  {
    print "0 widget_tell pb_df_1 bordercolor home #ff0000"; df_1_percent_blink[1] = 1;
  }

  if (df_1_percent_blink[2])
  { 
    print "0 widget_tell pb_df_1 bordercolor multi #663333"; df_1_percent_blink[2] = 0;
  }
  else if (df_1_percent[2] > 90)
  {
    print "0 widget_tell pb_df_1 bordercolor multi #ff0000"; df_1_percent_blink[2] = 1;
  }

  print ""; # flush (update) finally data inside awesome with this empty line
}

#EDIT above >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

{ 
  cpu_old_sum = cpu_old_idle = 0;
  eth_in_old_bytes = eth_out_old_bytes = 0;
  if (!DF_INTERVAL)
    DF_INTERVAL = 60; # check once in 60 loops (default)
  if (!MAIL_INTERVAL)
    MAIL_INTERVAL = 10; # check once in 10 loops (default)
  mail_interval_countdown = 0;
  df_interval_countdown = 0;

  # blinking variables initialising
  df_1_percent_blink[0] = 0;
  df_1_percent_blink[1] = 0;
  df_1_percent_blink[2] = 0;

  while (!system("sleep " INTERVAL))
  {
    ##################################################
    # date -> date_str

    if (DATE_STR)
    {
      DATE_CMD | getline date_str;
      close(DATE_CMD);
    }

    ##################################################
    # cpu -> cpu_percent
    # $2 = user, $3 = nice, $4 = system, $5 = idle (together = 100/second)
    # so diffs of: $2+$3+$4 / all-together * 100 = percent
    #          or: 100 - ( $5 / all-together) * 100 = percent
    #          or: 100 - 100 * ( $5 / all-together)= percent

    if (CPU_TOTAL || CPU_NICE || CPU_USER)
    {
      while ((getline < "/proc/stat") > 0)
      {
        close("/proc/stat"); # xxx: scanning only the first line/cpu for now
        break;
      }

      cpu_new_sum = $2 + $3 + $4 + $5; # all-together
      diff = cpu_new_sum - cpu_old_sum;

      # print "user diff:" $2 - cpu_old_user " nice diff:" $3 - cpu_old_nice\
      #            " idle diff:" $5 - cpu_old_idle " total diff:" diff

      if (diff > 0) # should be always (theoretically...)
      {
        cpu_user =  100 * ($2 - cpu_old_user) / diff;
        cpu_nice =  100 * ($3 - cpu_old_nice) / diff;
        cpu_total = 100 - 100 * ($5 - cpu_old_idle) / diff;
      }

      cpu_old_sum = cpu_new_sum;
      cpu_old_user = $2;
      cpu_old_nice = $3;
      cpu_old_idle = $5;
    }

    ##################################################
    # mem

    if (MEM_PERCENT || SWAP_PERCENT)
    {
      count = 0;
      while ((getline < "/proc/meminfo") > 0)
      {
        if ("MemFree:" == $1) # xxx: better use a 'case' maybe
        {
          mem_free = $2;
          count++;
        }
        else if ("MemTotal:" == $1)
        {
          mem_total = $2;
          count++;
        }
        else if ("SwapFree:" == $1)
        {
          swap_free = $2;
          count++;
        }
        else if ("SwapTotal:" == $1)
        {
          swap_total = $2;
          count++;
        }
        if (count >= 4)
        {
          break; # all info is there
        }
      }
      close("/proc/meminfo");

      mem_percent = 100 * (mem_total - mem_free) / mem_total;
      swap_percent = 100 * (swap_total - swap_free) / swap_total;
    }

    ##################################################
    # ethernet (in kb/update-interval (about a second))

    if (ETH_IN_KBS || ETH_OUT_KBS)
    {
      oldFS = FS;
      FS = "[: ]+";
      while ((getline < "/proc/net/dev") > 0)
      {
        if (match($0, /eth0/))
        {
          eth_in_kbs = sprintf("%5.1f", ($3 - eth_in_old_bytes) / 1024 / INTERVAL);
          eth_in_old_bytes = $3;
          eth_out_kbs = sprintf("%4.1f", ($11 - eth_out_old_bytes) / 1024 / INTERVAL);
          eth_out_old_bytes = $11;
          break;
        }
      }
      close("/proc/net/dev");
      FS = oldFS;
    }

    ##################################################
    # grep's for ^From in a mailbox (for mbox'es)

   # if (MAILBOX_COUNT && --mail_interval_countdown < 1)
   # {
   #   mailbox_count = 0;
   #   while ((getline < MAILBOX_FILE) > 0)
   #   {
   #     if (match($0, /^From [A-Za-z0-9._%+-]+/))
   #       mailbox_count++;
   #   }
   #   close(MAILBOX_FILE);
   #   mail_interval_countdown = MAIL_INTERVAL; # reset
   # }

    ##################################################
    # DF (disk-free) bar

    if (DF_1_PERCENT && --df_interval_countdown < 1)
    {
      z = 0;
      DF_CMD | getline; # ignore first line
      while ((DF_CMD | getline) > 0)
      {
        sub (/%/, "", $5)
        perc = ($5 - DF_RANGE) * (100 / (100 - DF_RANGE));
        if (perc < 0)
          perc = 0;
          df_1_percent[z++] = perc;
      }
      close(DF_CMD);
      df_interval_countdown = DF_INTERVAL; # reset
    }

    ##################################################
    # got that from: 
    # http://awesome.naquadah.org/wiki/index.php/Music_Player_Daemon_%28MPD%29

    if (MPD_MSG)
    {
      mpd_lines=0
      while (("mpc" | getline) > 0)
      {
        mpd_info[mpd_lines]=$0
        if (mpd_lines==1) {mpd_time=$3}
        mpd_lines+=1;
      }
      close("mpc");

      if (mpd_lines == 1)
        mpd_msg="mpd not playing";
      else
        mpd_msg=mpd_info[0];

      if (mpd_info[1] ~ /paused/) 
         mpd_msg = "<" mpd_msg ">";

      mpd_msg = mpd_msg" (" mpd_time ")"
    }

    ##################################################
    # more to add here.....

    ##################################################
    # print the collected data (see function at the top)

    print_data();
  } 
}
