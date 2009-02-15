#!/usr/bin/lua

--- Version 0.1
--- feel free to send me enhancements etc... (awesome mailing list, wiki, or mac@calmar.ws)

--==================================================
-- FUNCTIONS
--==================================================

----------------------------------------------------
--- add more funtions here.....
----------------------------------------------------
--.....
--.....
--.....

----------------------------------------------------
-- cpu -> cpu_percent
-- user + nice + system + idle = 100/second)
-- so diffs of: $2+$3+$4 / all-together * 100 = %
-- or: 100 - ( $5 / all-together) * 100 = %
-- or: 100 - 100 * ( $5 / all-together)= %
----------------------------------------------------

function cpu(cpuid)
  local line, cpu_new_sum, user, nice, system, idle, diff, fh
  local cpu_user, cpu_nice, cpu_total

  fh = io.open("/proc/stat")
  line = fh:read()
  while line do
    if string.match(line, cpuid) then
      user, nice, system, idle = string.match(line, "%w+%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")

      cpu_new_sum = user + nice + system + idle -- all-together
      diff = cpu_new_sum - cpu_old_sum;

      if diff > 0 then -- should be always true - but on heavy load no update is possible
        cpu_user =  100 * (user - cpu_old_user) / diff;
        cpu_nice =  100 * (nice - cpu_old_nice) / diff;
        cpu_total = 100 - 100 * (idle - cpu_old_idle) / diff;
      else
        cpu_user = 100
        cpu_nice = 100
        cpu_total = 100
      end

      cpu_old_sum = cpu_new_sum;
      cpu_old_user = user;
      cpu_old_nice = nice;
      cpu_old_idle = idle;

      io.close(fh);
      return {cpu_user, cpu_nice, cpu_total}
    end
    line = fh:read()
  end
  io.close(fh);
end

----------------------------------------------------
-- memory
----------------------------------------------------
-- todo: Mem{Swap}Total would be needed only once!
function memory(proc)
  local mem_free, mem_total, swap_free, swap_total
  local mem_percent, swap_percent, line, fh, count
  count = 0

  fh = io.open(proc)

  line = fh:read()
  while line and count < 4 do
    if line:match("MemFree:") then
      mem_free = string.match(line, "%d+")
      count = count + 1;
    elseif line:match("MemTotal:") then
      mem_total = string.match(line, "%d+")
      count = count + 1;
    elseif line:match("SwapFree:") then
      swap_free = string.match(line, "%d+")
      count = count + 1;
    elseif line:match("SwapTotal:") then
      swap_total = string.match(line, "%d+")
      count = count + 1;
    end
    line = fh:read()
  end
  io.close(fh)

  mem_percent = 100 * (mem_total - mem_free) / mem_total;
  swap_percent = 100 * (swap_total - swap_free) / swap_total;

  return {mem_percent, swap_percent}
end

----------------------------------------------------
-- ethernet (in kb/update-interval)
----------------------------------------------------
function ethernet(eth)
  local tot_eth_in, tot_eth_out, tmp, fh
  local eth_in, eth_out, eth_in_perc, eth_out_perc

  fh = io.open("/proc/net/dev")
  line = fh:read()
  while line do
    if string.match(line, eth) then
      mp = string.find (line,":") -- skip the 0 on ehth0
      tot_eth_in = string.match(line, "%d+", tmp) -- first decimal number are total bytes
      tot_eth_out = string.gsub(line,"^.*:+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+).*$", "%1")
      eth_in = (tot_eth_in - tot_eth_in_old) / 1024 -- / INTERVAL
      eth_out = (tot_eth_out - tot_eth_out_old) / 1024 -- / INTERVAL
      eth_in_perc = eth_in * 100 / ETH_MAX_IN;
      eth_out_perc = eth_out * 100 / ETH_MAX_OUT;

      tot_eth_in_old = tot_eth_in
      tot_eth_out_old = tot_eth_out
      eth_in = string.format("%5.1f", eth_in)
      eth_out = string.format("%4.1f", eth_out)

      io.close(fh);
      return {eth_in, eth_in_perc, eth_out, eth_out_perc}
    end
    line = fh:read()
  end
  io.close(fh);
end

----------------------------------------------------
-- grep's for ^From in a mailbox (for mbox'es)
----------------------------------------------------
--function mailbox_count(mbox)
--  local count, line
--  count = 0
--  for line in io.lines(mbox) do
--    if string.match(line, "^From [%w_\%+-]+") then
--      count = count + 1
--    end
--  end
--  return count
--end

----------------------------------------------------
-- DF (disk-free) bar
----------------------------------------------------
function diskfree(cmd, range)
  local z, line, ph, df
  df = {}
  z = 1
  ph = io.popen(cmd)
  line = ph:read() -- skip first line
  line = ph:read()
  while line do
    perc = string.gsub(line, "^[^%s]+%s+[^%s]+%s+[^%s]+%s+[^%s]+%s+(%w+).+$", "%1")
    perc = (perc - range) * (100 / (100 - range))
    if (perc < 0) then
      perc = 0;
    end
    df[z] = perc;
    z = z + 1
    line = ph:read()
  end
  io.close(ph);
  return df
end

--============================
-- init some global variables
--============================
tot_eth_in_old = 0
tot_eth_out_old = 0
df_interval = 0
mailbox_interval = 0
cpu_old_sum = 0
cpu_old_user = 0
cpu_old_nice = 0
cpu_old_idle = 0

df_data = {} -- blinking variables initialising for df
df_blink = {}
df_blink[1] = false
df_blink[2] = false
df_blink[3] = false

--====================
-- set some constants
--====================
INTERVAL = 0.992        -- in seconds (note not all 'sleep' allow floats!, use an iteger then).
                        -- somebit less than a second, because the script takes some time itself.

ETH_MAX_IN = 448000     -- ethernet maximum values in bytes/second
ETH_MAX_OUT = 52800
os.setlocale("us_US")   -- date must not return special language chars - won't work else with awesome

--==================================================
-- main loop
--==================================================
while os.execute("sleep "..INTERVAL) do 

  data = cpu("cpu0")
  out = "0 widget_tell gr_cpu data user "..data[1].."\n"
  out = out.."0 widget_tell gr_cpu data nice "..data[2].."\n"
  out = out.."0 widget_tell gr_cpu data total "..data[3].."\n"

  data = ethernet("eth0")
  out = out.."0 widget_tell tb_net_in text "..data[1].."\n"
  out = out.."0 widget_tell gr_net data in "..data[2].."\n"
  out = out.."0 widget_tell tb_net_out text "..data[3].."\n"
  out = out.."0 widget_tell gr_net data out "..data[4].."\n"

  data = memory("/proc/meminfo")
  out = out.."0 widget_tell pb_mem data mem "..data[1].."\n"
  out = out.."0 widget_tell pb_mem data swap "..data[2].."\n"

  df_interval = df_interval - 1
  if df_interval < 1 then
    df_data = diskfree("df /dev/sda12 /dev/sda13 /dev/sda8", 80) -- command, range e.g. show (80-100)
    out = out.."0 widget_tell pb_df_1 data root "..df_data[1].."\n"
    out = out.."0 widget_tell pb_df_1 data home "..df_data[2].."\n"
    out = out.."0 widget_tell pb_df_1 data multi "..df_data[3].."\n"
    df_interval = 20 -- only diskfree() each 20'th loop
  end

  --mailbox_interval = mailbox_interval - 1
  --if mailbox_interval < 1 then
  --  value = mailbox_count("/home/qianli/.mail/inbox") -- a mbox
  --  out = out.."0 widget_tell tb_mail text "..value.."\n"
  --  mailbox_interval = 10
 -- end

  value = os.date("%X %a, %e %b")
  out = out.."0 widget_tell tb_date text "..value.." ".."\n"

  ---------------------------
  -- blinking (alarm) for df
  ---------------------------
  if df_blink[1] then -- reset color
    out = out.."0 widget_tell pb_df_1 bordercolor root #4444cc".."\n"; df_blink[1] = false
  elseif df_data[1] > 30 then -- blink when value > x
    out = out.."0 widget_tell pb_df_1 bordercolor root #ff0000".."\n"; df_blink[1] = true
  end
  if df_blink[2] then
    out = out.."0 widget_tell pb_df_1 bordercolor home #336633".."\n"; df_blink[2] = false
  elseif df_data[2] > 80 then
    out = out.."0 widget_tell pb_df_1 bordercolor home #ff0000".."\n"; df_blink[2] = true
  end
  if df_blink[3] then
    out = out.."0 widget_tell pb_df_1 bordercolor multi #663333".."\n"; df_blink[3] = false
  elseif df_data[3] > 90 then
    out = out.."0 widget_tell pb_df_1 bordercolor multi #ff0000".."\n"; df_blink[3] = true
  end

  -----------------
  -- print finally
  -----------------
  print(out) -- includes an empty line
  io.flush()
end
