// Js file for extracting the parameters (from http://www.javascripter.net/faq/greekletters.htm)
var mAlpha,
mBeta,
mGamma,
mDelta,
mMu;

sliderVal();

// Look out for change in input
var sliders = document.getElementById('parameters');
var inputs = sliders.getElementsByTagName('input');

for (var i = 0; i < 5; i++) {
	inputs[i].oninput = sliderVal;
}

function sliderVal() {
	mAlpha = document.getElementById('alphaSelect').value;
	mBeta = document.getElementById('betaSelect').value;
	mGamma = document.getElementById('gammaSelect').value;
	mDelta = document.getElementById('deltaSelect').value;
	mMu = document.getElementById('muSelect').value;

    // Show the value of the sliders
    // console.log(mAlpha, beta, gamma);
    document.getElementById('alphaVal').innerHTML = mAlpha;
    document.getElementById('betaVal').innerHTML = mBeta;
    document.getElementById('gammaVal').innerHTML = mGamma;
    document.getElementById('deltaVal').innerHTML = mDelta;
    document.getElementById('muVal').innerHTML = mMu;
}