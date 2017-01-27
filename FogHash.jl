# Solution is present stream-of-consciousness as it was discovered

# The hash of the word we're looking for
hashGoal = 910897038977002

# A character's value is its 0-based index in this alphabet
alphabet = "acdegilmnoprstuw"
charToN(ch) = search(alphabet, ch) - 1
stringToNs(s) = map(charToN, collect(s))

# Hash function as described in job posting
fogHash(ns) = reduce((acc, n) -> acc * 37 + n, 7, ns)

# Test hash function with provided example test string and hash value
testString = "leepadg"
testExpected = 680131659347
testResult = fogHash(stringToNs(testString))
@assert(testResult == testExpected, "example string does not hash to expected value")

# Each character has a value between 0 and 15.
# Since the accumulated hash is multiplied by 37 before each character,
# a character earlier in the string always has a greater effect on
# the resulting hash than a later value.
@assert(fogHash([15, 0]) > fogHash([0, 15]), "expected greater value earlier in string to have greater effect")

# Therefore,

# 1) The greatest factor in the scale of the resulting value
#    is the length of the input string.
minN = 0
maxN = length(alphabet) - 1
minNs(len) = repeat([minN], outer=[len])
maxNs(len) = repeat([maxN], outer=[len])
minHashN(len) = fogHash(minNs(len))
maxHashN(len) = fogHash(maxNs(len))
containsGoal(len) = (minHashN(len) <= hashGoal) && (hashGoal <= maxHashN(len))
nsLength = findfirst(containsGoal, 0:30) - 1
@assert(nsLength == 9, "string length was expected to be 9")

# 2) We can scan each character upward, starting with the
#    first, most significant one. Stop incrementing when
#    we would exceed the target value.
incAt(ns, i) = ns[i] = ns[i] + 1
decAt(ns, i) = ns[i] = ns[i] - 1
scanAt(ns, i) =
    begin
        while fogHash(ns) <= hashGoal
            incAt(ns, i)
        end
        decAt(ns, i)
    end
scanAccross(ns, len) =
    for i = 1:len
        scanAt(ns, i)
    end
resultNs = minNs(nsLength)
scanAccross(resultNs, nsLength)
backToString(ns) = join(map(n -> alphabet[n + 1], ns))
resultString = backToString(resultNs)
@assert(resultString == "asparagus", "Did not get expected result string, got \"$resultString\"")

println("Success!")
println("The code word is: $resultString")

# If we had to brute force every possibility, even given we knew the length was 9,
# that would require checking 16 ^ 9 = 68,719,476,736 strings. By exploting what we
# know about the algorithm, particularly the fact that the earlier characters always
# have a greater impact on the resulting hash value than the later characters, we
# only have to scan up to 16 * 9 = 144 possibilities.

# That's 480 million times faster!
