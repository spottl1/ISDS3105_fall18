Assignment 2
================
Seth Pottle

The goal of this practice is to improve your understanding of vectors and how to manipulate them. The data we use are the prices of the [2017 Big Mac Index](http://www.economist.com/content/big-mac-index).

For each question, please create a new chunk with your reponse. Use narratives to comment the output whenever the question requires to do so.

1.  Edit the code below to assign country names to the vector `countries` and prices to the vector `prices`. Hide the code below when you knit (check the Rmarkdown cheatsheet to find the appropriate chunk option to hide code).

2.  Use `typeof()` to report the type of both vectors.

``` r
typeof(countries)
```

    ## [1] "character"

``` r
typeof(prices)
```

    ## [1] "double"

1.  Use `names()` to name the `prices` using `countries`. Show the first 5 values of your new vector

``` r
names(prices) <- countries
prices[1:5]
```

    ## Argentina Australia    Brazil   Britain    Canada 
    ##  4.125534  4.527955  5.101568  4.111432  4.655697

1.  Use `round()` to round the prices at the 3rd decimal. Overwrite `prices` with the rounded prices.

``` r
prices <- round(prices, 3)
prices
```

    ##      Argentina      Australia         Brazil        Britain         Canada 
    ##          4.126          4.528          5.102          4.111          4.656 
    ##          Chile          China       Colombia     Costa Rica Czech Republic 
    ##          3.844          2.917          3.244          4.000          3.281 
    ##        Denmark          Egypt      Euro area      Hong Kong        Hungary 
    ##          4.606          1.754          4.465          2.458          3.209 
    ##          India      Indonesia         Israel          Japan       Malaysia 
    ##          2.757          2.403          4.773          3.361          2.003 
    ##         Mexico    New Zealand         Norway       Pakistan           Peru 
    ##          2.754          4.432          5.914          3.566          3.229 
    ##    Philippines         Poland         Russia   Saudi Arabia      Singapore 
    ##          2.649          2.723          2.278          3.200          4.065 
    ##   South Africa    South Korea      Sri Lanka         Sweden    Switzerland 
    ##          2.261          3.844          3.773          5.819          6.742 
    ##         Taiwan       Thailand         Turkey            UAE        Ukraine 
    ##          2.264          3.496          3.006          3.812          1.698 
    ##  United States        Uruguay      Venezuela        Vietnam        Austria 
    ##          5.300          4.529          4.056          2.639          3.883 
    ##        Belgium        Estonia        Finland         France        Germany 
    ##          4.625          3.597          5.207          4.682          4.454 
    ##         Greece        Ireland          Italy    Netherlands       Portugal 
    ##          3.826          4.648          4.796          4.122          3.711 
    ##          Spain 
    ##          4.339

1.  Use indexing to report the prices for Canada, United States, Mexico

``` r
prices[c("Canada", "United States", "Mexico")]
```

    ##        Canada United States        Mexico 
    ##         4.656         5.300         2.754

1.  Use inline code and the function `length()` to display the following sentence:

"There are x observations in the Big-Mac Index"

1.  Convert the prices from Dollar to Euro (1 Dollar = .83 Euro). In the narrative, comment about the property which allows you to combine a vector of length 1 (the exchange rate) with a vector of length 56 (the prices).

``` r
prices*0.83
```

    ##      Argentina      Australia         Brazil        Britain         Canada 
    ##        3.42458        3.75824        4.23466        3.41213        3.86448 
    ##          Chile          China       Colombia     Costa Rica Czech Republic 
    ##        3.19052        2.42111        2.69252        3.32000        2.72323 
    ##        Denmark          Egypt      Euro area      Hong Kong        Hungary 
    ##        3.82298        1.45582        3.70595        2.04014        2.66347 
    ##          India      Indonesia         Israel          Japan       Malaysia 
    ##        2.28831        1.99449        3.96159        2.78963        1.66249 
    ##         Mexico    New Zealand         Norway       Pakistan           Peru 
    ##        2.28582        3.67856        4.90862        2.95978        2.68007 
    ##    Philippines         Poland         Russia   Saudi Arabia      Singapore 
    ##        2.19867        2.26009        1.89074        2.65600        3.37395 
    ##   South Africa    South Korea      Sri Lanka         Sweden    Switzerland 
    ##        1.87663        3.19052        3.13159        4.82977        5.59586 
    ##         Taiwan       Thailand         Turkey            UAE        Ukraine 
    ##        1.87912        2.90168        2.49498        3.16396        1.40934 
    ##  United States        Uruguay      Venezuela        Vietnam        Austria 
    ##        4.39900        3.75907        3.36648        2.19037        3.22289 
    ##        Belgium        Estonia        Finland         France        Germany 
    ##        3.83875        2.98551        4.32181        3.88606        3.69682 
    ##         Greece        Ireland          Italy    Netherlands       Portugal 
    ##        3.17558        3.85784        3.98068        3.42126        3.08013 
    ##          Spain 
    ##        3.60137

``` r
#multiplying a vector of length 56 by a vector of length 1 applies the resulting product of each element to the vector of length 56
```

-   Could you use the vector `rep(.83, 28)` to do the same?

``` r
prices * rep(.83, 28)
```

    ##      Argentina      Australia         Brazil        Britain         Canada 
    ##        3.42458        3.75824        4.23466        3.41213        3.86448 
    ##          Chile          China       Colombia     Costa Rica Czech Republic 
    ##        3.19052        2.42111        2.69252        3.32000        2.72323 
    ##        Denmark          Egypt      Euro area      Hong Kong        Hungary 
    ##        3.82298        1.45582        3.70595        2.04014        2.66347 
    ##          India      Indonesia         Israel          Japan       Malaysia 
    ##        2.28831        1.99449        3.96159        2.78963        1.66249 
    ##         Mexico    New Zealand         Norway       Pakistan           Peru 
    ##        2.28582        3.67856        4.90862        2.95978        2.68007 
    ##    Philippines         Poland         Russia   Saudi Arabia      Singapore 
    ##        2.19867        2.26009        1.89074        2.65600        3.37395 
    ##   South Africa    South Korea      Sri Lanka         Sweden    Switzerland 
    ##        1.87663        3.19052        3.13159        4.82977        5.59586 
    ##         Taiwan       Thailand         Turkey            UAE        Ukraine 
    ##        1.87912        2.90168        2.49498        3.16396        1.40934 
    ##  United States        Uruguay      Venezuela        Vietnam        Austria 
    ##        4.39900        3.75907        3.36648        2.19037        3.22289 
    ##        Belgium        Estonia        Finland         France        Germany 
    ##        3.83875        2.98551        4.32181        3.88606        3.69682 
    ##         Greece        Ireland          Italy    Netherlands       Portugal 
    ##        3.17558        3.85784        3.98068        3.42126        3.08013 
    ##          Spain 
    ##        3.60137

Yes, it has the same output because 28 is a factor of 56 (the length of the prices vector).

-   Could you use the vector `rep(.83, 112)` to do the same?

``` r
prices * rep(.83, 112)
```

    ##   [1] 3.42458 3.75824 4.23466 3.41213 3.86448 3.19052 2.42111 2.69252
    ##   [9] 3.32000 2.72323 3.82298 1.45582 3.70595 2.04014 2.66347 2.28831
    ##  [17] 1.99449 3.96159 2.78963 1.66249 2.28582 3.67856 4.90862 2.95978
    ##  [25] 2.68007 2.19867 2.26009 1.89074 2.65600 3.37395 1.87663 3.19052
    ##  [33] 3.13159 4.82977 5.59586 1.87912 2.90168 2.49498 3.16396 1.40934
    ##  [41] 4.39900 3.75907 3.36648 2.19037 3.22289 3.83875 2.98551 4.32181
    ##  [49] 3.88606 3.69682 3.17558 3.85784 3.98068 3.42126 3.08013 3.60137
    ##  [57] 3.42458 3.75824 4.23466 3.41213 3.86448 3.19052 2.42111 2.69252
    ##  [65] 3.32000 2.72323 3.82298 1.45582 3.70595 2.04014 2.66347 2.28831
    ##  [73] 1.99449 3.96159 2.78963 1.66249 2.28582 3.67856 4.90862 2.95978
    ##  [81] 2.68007 2.19867 2.26009 1.89074 2.65600 3.37395 1.87663 3.19052
    ##  [89] 3.13159 4.82977 5.59586 1.87912 2.90168 2.49498 3.16396 1.40934
    ##  [97] 4.39900 3.75907 3.36648 2.19037 3.22289 3.83875 2.98551 4.32181
    ## [105] 3.88606 3.69682 3.17558 3.85784 3.98068 3.42126 3.08013 3.60137

The `rep` command has an argument of 112, double the size of the prices vector. Therefore, the command prints the output of prices twice.

-   Would `rep(.83, 45)` also work? Why?

``` r
prices * rep(.83, 45)
```

    ## Warning in prices * rep(0.83, 45): longer object length is not a multiple
    ## of shorter object length

    ##      Argentina      Australia         Brazil        Britain         Canada 
    ##        3.42458        3.75824        4.23466        3.41213        3.86448 
    ##          Chile          China       Colombia     Costa Rica Czech Republic 
    ##        3.19052        2.42111        2.69252        3.32000        2.72323 
    ##        Denmark          Egypt      Euro area      Hong Kong        Hungary 
    ##        3.82298        1.45582        3.70595        2.04014        2.66347 
    ##          India      Indonesia         Israel          Japan       Malaysia 
    ##        2.28831        1.99449        3.96159        2.78963        1.66249 
    ##         Mexico    New Zealand         Norway       Pakistan           Peru 
    ##        2.28582        3.67856        4.90862        2.95978        2.68007 
    ##    Philippines         Poland         Russia   Saudi Arabia      Singapore 
    ##        2.19867        2.26009        1.89074        2.65600        3.37395 
    ##   South Africa    South Korea      Sri Lanka         Sweden    Switzerland 
    ##        1.87663        3.19052        3.13159        4.82977        5.59586 
    ##         Taiwan       Thailand         Turkey            UAE        Ukraine 
    ##        1.87912        2.90168        2.49498        3.16396        1.40934 
    ##  United States        Uruguay      Venezuela        Vietnam        Austria 
    ##        4.39900        3.75907        3.36648        2.19037        3.22289 
    ##        Belgium        Estonia        Finland         France        Germany 
    ##        3.83875        2.98551        4.32181        3.88606        3.69682 
    ##         Greece        Ireland          Italy    Netherlands       Portugal 
    ##        3.17558        3.85784        3.98068        3.42126        3.08013 
    ##          Spain 
    ##        3.60137

This still works, but comes with a warning message because 56 is not a multiple of 45.

1.  In your narrative, mention that we are going to drop the 46th element. Use dynamic code to report the country that will drop.

``` r
cat("We will drop", countries[46], "from the the prices vector")
```

    ## We will drop Belgium from the the prices vector

1.  Overwrite the vector of prices with a new vector without observation 46. Use `length()` to make sure you have one observation less.

``` r
prices <- prices[-c(46)]
length(prices)
```

    ## [1] 55

1.  Knit, commit and push to your GitHub repo `assignment`. Then submit the link to the *assignment folder* on Moodle.
