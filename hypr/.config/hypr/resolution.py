res_real           = [1920, 1080]
perc_min, perc_max = 0.8, 1.0
decimals, roundto  = 6, 5

resolution         = 10**decimals
perc_min, perc_max = [int(i*resolution) for i in [perc_min, perc_max]]

for scale in range(perc_min,perc_max+1,1):
    scale       /= resolution
    calc_res     = lambda r : round(r / scale, roundto)
    res_virtual  = [calc_res(res_way)  for res_way in res_real]
    if res_virtual[0].is_integer() and res_virtual[0].is_integer():
        print(scale, res_virtual)
