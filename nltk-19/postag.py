import nltk
from nltk.corpus import brown
from nltk.tag import UnigramTagger, BigramTagger, TrigramTagger

def train_model(training_tag):
    tag_list = []
    for sents in training_tag:
        for group in sents:
            tag_list.append(group[1])
    defaultTag = nltk.FreqDist(tag_list).max()
    df = nltk.DefaultTagger(defaultTag)
    tagger = UnigramTagger(training_tag, backoff = df)
    bitagger = BigramTagger(training_tag, backoff = df)
    a = tagger.evaluate(training_tag)
    b = bitagger.evaluate(training_tag)
    if a > b:
        return tagger
    else:
        return bitagger

def run(model, sents):
    for word, tag in model.tag(sents):
        out = (word, tag)
        print(out)

def test(model, test_tag):
    print(model.evaluate(test_tag))
    return model.evaluate(test_tag)


if __name__ == '__main__':
    training_model = train_model(brown.tagged_sents(categories = 'news'))
    run(training_model, ['I', 'want', 'to', 'test', 'a', 'model', '.'])
    test(training_model, brown.tagged_sents(categories = 'news'))
    test(training_model, brown.tagged_sents(categories = 'reviews'))