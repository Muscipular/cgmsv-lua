---@alias �ַ��� string
---@alias ��ֵ�� number


---��ȡ�䷽ָ����Ϣ������
---@param recipeNo number �䷽id
---@param dataLine CONST.ITEM_RECIPE
---@return any @ָ����Ϣ����Ϣ
function Recipe.GetData(recipeNo, dataLine) end

---ָ���䷽ָ����Ϣ������
---@param recipeNo number �䷽id
---@param dataLine CONST.ITEM_RECIPE
---@param val ָ��ֵ
---@return any @
function Recipe.SetData(recipeNo, dataLine,val) end

---ϰ���䷽
---@param charIndex number ����index
---@param recipeNo number �䷽id
---@return number @�ɹ�ʱ���� 1, ʧ�ܷ��� 0, charIndex��Ч���� -1, �䷽��Ч���� -2, �䷽�ѻ�÷��� -3
function Recipe.GiveRecipe(charIndex, recipeNo) end

---ɾ���䷽
---@param charIndex number ����index
---@param recipeNo number �䷽id
---@return number @�ɹ�ʱ���� 1, ʧ�ܷ��� 0, charIndex��Ч���� -1, �䷽��Ч���� -2, �䷽�ѻ�÷��� -3
function Recipe.RemoveRecipe(charIndex, recipeNo) end

---�ж��Ƿ�ѧ���䷽
---@param charIndex number ����index
---@param recipeNo number �䷽id CONST.RECIPE
---@return number @����ֵ ���䷽ʱ���� 1, ���䷽���� 0, charIndex��Ч���� -1, �䷽��Ч���� -2
function Recipe.HasRecipe(charIndex, recipeNo) end
