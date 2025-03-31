PROJ_NAME = 'bitty_hackaton'

#============================================================= parsers
def parse_util():
    UTIL_REP_FILE = './tmp/' + PROJ_NAME + '/' + PROJ_NAME + '.fit.summary'
    # UTIL_REP_FILE = './utilization.txt'

    alm = 0
    ram  = 0
    dsp   = 0
    
    try: 
        f = open(UTIL_REP_FILE, 'r')
        s = f.readline()
        while s:
            # ALMs used.
            if "Logic" in s:
                s = s.split()
                alm += int(s[5])
            
            # RAM used.
            elif "Total RAM" in s:
                s = s.split()
                ram += int(s[4])

            # DSP used.
            elif "Total DSP" in s:
                s = s.split()
                ram += int(s[4])

            s = f.readline()
        f.close()
    
    except FileNotFoundError:
        print(f"Error: File '{UTIL_REP_FILE}' not found.")
        print("Make sure you have successfully compiled the design!")
        return None
    return (alm, ram, dsp)

def parse_timing():
    TIMING_REP_FILE = './tmp/' + PROJ_NAME + '/' + PROJ_NAME + '.sta.summary'
    # TIMING_REP_FILE = './timing.txt'

    WNS = 0
    TNS = 0
    
    try:
        f = open(TIMING_REP_FILE, 'r')
        s = f.readline()
        while s:
            if (s == 'Type  : Slow 1100mV 85C Model Setup \'clk\'\n'):
                s = f.readline()
                s = s.split()
                WNS = float(s[2])
                s = f.readline()
                s = s.split()
                TNS = float(s[2])
                break
            s = f.readline()
        f.close()

    except FileNotFoundError:
        print(f"Error: File '{TIMING_REP_FILE}' not found.")
        print("Make sure you have successfully compiled the design!")
        return None
    return (WNS, TNS)
#============================================================= parsers : end

#============================================================= calc
def calc_area(alm, ram, dsp):
    return alm + 92.2 * ram + 45.5 * dsp

def calc_fmax(WNS, _):
    PERIOD = 4
    return 1/(PERIOD-WNS)*1000
#============================================================= calc : end

#============================================================= printer
def result_form(utilization, timings, area, fmax):
    separator = '\n========================================================\n'
    table_sep = '\n|--------------|--------------|\n'
    table_head1 = '|' + '|'.join(['Area'  .rjust(14), 
                                  'Fmax, MHz'.rjust(14)]) + '|'

    result  = separator
    result += '\nMetrics:\n\n'
    result += 'WNS:\t'    + format(timings[0], '.3f').rjust(12) + '\n'
    result += 'TNS:\t'    + format(timings[1], '.3f').rjust(12) + '\n'
    result += 'ALMs:\t' + format(utilization[0], '.3f').rjust(12) + '\n'
    result += 'RAMs:\t'  + format(utilization[1], '.3f').rjust(12) + '\n'
    result += 'DSPs:\t'   + format(utilization[2], '.3f').rjust(12) + '\n'

    result += table_sep + table_head1 + table_sep
    temp = (format(area, '.3f').rjust(14),  
            format(fmax, '.3f').rjust(14))
    result += '|'+'|'.join(temp)+'|' + table_sep + separator

    return result
#============================================================= printer : end

#============================================================= main
utilization = parse_util()
timings     = parse_timing()

area = calc_area(*utilization)
fmax = calc_fmax(*timings)

result = result_form(utilization, timings, area, fmax)

print(result)

# RESULT_FILE = './tmp/result/result.txt'
RESULT_FILE = './result.txt'
f = open(RESULT_FILE, 'w')
f.write(result)
f.close()
#============================================================= main : end
