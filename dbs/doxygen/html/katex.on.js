$(function(){

$('img.formulaInl').each(embed);

$('img.formulaDsp').each(embed);

function embed()
{
  var formula = this.alt;
  var standalone = !/\$/.test(formula);
  var skip = standalone ? 2 : 1;
  formula = formula.substring(skip);
  formula = formula.substring(0, formula.length - skip);
  formula = katex.renderToString(formula, {displayMode: standalone});
  $(this).wrap('<span>').parent().html(formula);
}

});
