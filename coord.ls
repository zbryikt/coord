# forumal adopted from 
# http://blog.ez2learn.com/2009/08/15/lat-lon-to-twd97/
# http://sask989.blogspot.tw/2012/05/wgs84totwd97.html
# example
#   coord.to-twd97 {lat: 25.040280669021932, lng: 121.50378056709678}
#   coord.to-gws84 300835.44, 2770333.73

coord =
  a: 6378137.0
  b: 6356752.3142451
  k0: 0.9999
  dx: 250000
  dy: 0
  lng0: 121 * Math.PI / 180
  init: ->
    {a,b} = @
    @e = 1 - Math.pow(b, 2) / Math.pow(a, 2)
    @e2 = (1 - Math.pow(b, 2) / Math.pow(a, 2)) / (Math.pow(b, 2) / Math.pow(a, 2))
    @init = null

  rad: -> it * Math.PI / 180

  to-twd97: ({lat, lng}) ->
    if @init => @init!
    {a,b,k0,dx,dy,lng0,e,e2} = @
    lng = (lng - Math.floor((lng + 180) / 360) * 360) * Math.PI / 180
    lat = lat * Math.PI / 180
    V = a / Math.sqrt(1 - e * (Math.sin(lat) ** 2))
    T = Math.tan(lat) ** 2
    C = e2 * Math.cos(lat) ** 2
    A = Math.cos(lat) * (lng - lng0)
    M = a *((1.0 - e / 4.0 - 3.0 * (e ** 2) / 64.0 - 5.0 * (e ** 3) / 256.0) * lat -
          (3.0 * e / 8.0 + 3.0 * (e ** 2) / 32.0 + 45.0 * (e ** 3) / 1024.0) *
          Math.sin(2.0 * lat) + (15.0 * (e ** 2) / 256.0 + 45.0 * (e ** 3) / 1024.0) * 
          Math.sin(4.0 * lat) - (35.0 * (e ** 3) / 3072.0) * Math.sin(6.0 * lat))
    x = dx + k0 * V * (A + (1 - T + C) * (A ** 3) / 6 + (5 - 18 * T + (T ** 2) + 72 * C - 58 * e2) * (A ** 5) / 120)
    y = dy + k0 * (M + V * Math.tan(lat) * ((A ** 2) / 2 + (5 - T + 9 * C + 4 * (C ** 2)) * (A ** 4) / 24 + ( 61 - 58 * T + (T ** 2) + 600 * C - 330 * e2) * (A ** 6) / 720))
    return [x, y]

  to-gws84: (x, y) ->
    if @init => @init!
    {a,b,k0,dx,dy,lng0,e,e2} = @
    [x, y] = [x - dx, y - dy]

    M = y / k0

    mu = M / (a * (1.0 - e / 4.0 - 3 * Math.pow(e, 2) / 64.0 - 5 * Math.pow(e, 3) / 256.0))
    e1 = (1.0 - Math.sqrt(1.0 - e)) / (1.0 + Math.sqrt(1.0 - e))

    J1 = (3 * e1 / 2 - 27 * Math.pow(e1, 3) / 32.0)
    J2 = (21 * Math.pow(e1, 2) / 16 - 55 * Math.pow(e1, 4) / 32.0)
    J3 = (151 * Math.pow(e1, 3) / 96.0)
    J4 = (1097 * Math.pow(e1, 4) / 512.0)

    fp = mu + J1 * Math.sin(2 * mu) + J2 * Math.sin(4 * mu) + J3 * Math.sin(6 * mu) + J4 * Math.sin(8 * mu)

    C1 = e2 * Math.pow(Math.cos(fp), 2)
    T1 = Math.pow(Math.tan(fp), 2)
    R1 = a * (1 - e) / Math.pow((1 - e * Math.pow(Math.sin(fp), 2)), (3.0 / 2.0))
    N1 = a / Math.pow((1 - e * Math.pow(Math.sin(fp), 2)), 0.5)

    D = x / (N1 * k0)

    Q1 = N1 * Math.tan(fp) / R1
    Q2 = (Math.pow(D, 2) / 2.0)
    Q3 = (5 + 3 * T1 + 10 * C1 - 4 * Math.pow(C1, 2) - 9 * e2) * Math.pow(D, 4) / 24.0
    Q4 = (61 + 90 * T1 + 298 * C1 + 45 * Math.pow(T1, 2) - 3 * Math.pow(C1, 2) - 252 * e2) * Math.pow(D, 6) / 720.0
    lat = fp - Q1 * (Q2 - Q3 + Q4)

    Q5 = D
    Q6 = (1 + 2 * T1 + C1) * Math.pow(D, 3) / 6
    Q7 = (5 - 2 * C1 + 28 * T1 - 3 * Math.pow(C1, 2) + 8 * e2 + 24 * Math.pow(T1, 2)) * Math.pow(D, 5) / 120.0
    lng = lng0 + (Q5 - Q6 + Q7) / Math.cos(fp)

    lat = (lat * 180) / Math.PI
    lng = (lng * 180) / Math.PI
    return {lat, lng}

(if @window? => @coord = {} else @) <<< coord
