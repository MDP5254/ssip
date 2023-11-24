import pickle
import tensorflow as tf

model=pickle.load(open("SVM_model.pkl",'rb'))
cv=pickle.load(open("vec_model.pkl",'rb'))


def check(instance):
    vec=cv.transform([instance])
    prediction=model.predict(vec)
    result=0
    if prediction[0]==1:
        result=1
    else:
        result=0
    return result


if __name__ == '__main__':
    print(check('Fuck You'))