module.exports = function isUserOne(userList, userId){
    userList.sort();
    const result = userList.findIndex((x) => x === userId);
    return result === 0;
};

